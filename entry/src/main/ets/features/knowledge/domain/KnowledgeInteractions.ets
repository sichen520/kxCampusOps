import { KnowledgeResource } from '../../../domain/WorkflowModels';

const MAX_COUNTER: number = 2147483647;

export interface ResourceInteraction {
  resourceId: string;
  viewRecorded: boolean;
  downloadCount: number;
  favorite: boolean;
  rating: number;
  reported: boolean;
}

function normalizedId(resourceId: string): string {
  return resourceId.trim();
}

function normalizedCounter(value: number): number {
  if (!Number.isFinite(value) || value <= 0) {
    return 0;
  }
  return Math.min(MAX_COUNTER, Math.floor(value));
}

function normalizedRating(value: number): number {
  if (!Number.isFinite(value) || Math.floor(value) !== value || value < 1 || value > 5) {
    return 0;
  }
  return value;
}

function copyInteraction(interaction: ResourceInteraction): ResourceInteraction {
  const resourceId: string = normalizedId(interaction.resourceId);
  if (resourceId.length === 0) {
    return empty('');
  }
  return {
    resourceId: resourceId,
    viewRecorded: interaction.viewRecorded,
    downloadCount: normalizedCounter(interaction.downloadCount),
    favorite: interaction.favorite,
    rating: normalizedRating(interaction.rating),
    reported: interaction.reported
  };
}

function copyResource(resource: KnowledgeResource): KnowledgeResource {
  return {
    id: resource.id,
    category: resource.category,
    resourceType: resource.resourceType,
    title: resource.title,
    summary: resource.summary,
    author: resource.author,
    courseName: resource.courseName,
    college: resource.college,
    major: resource.major,
    teacherName: resource.teacherName,
    permission: resource.permission,
    tags: resource.tags.slice(),
    viewCount: resource.viewCount,
    downloadCount: resource.downloadCount,
    favoriteCount: resource.favoriteCount,
    averageRating: resource.averageRating,
    ratingCount: resource.ratingCount,
    createdAt: resource.createdAt,
    fileName: resource.fileName,
    attachmentRawFile: resource.attachmentRawFile
  };
}

function interactionForResource(resourceId: string, interaction: ResourceInteraction): ResourceInteraction {
  const candidate: ResourceInteraction = copyInteraction(interaction);
  return candidate.resourceId === resourceId ? candidate : empty(resourceId);
}

function roundedRating(value: number): number {
  return Math.round(value * 100) / 100;
}

export function empty(resourceId: string): ResourceInteraction {
  return {
    resourceId: normalizedId(resourceId),
    viewRecorded: false,
    downloadCount: 0,
    favorite: false,
    rating: 0,
    reported: false
  };
}

export function findOrCreate(
  interactions: ResourceInteraction[],
  resourceId: string
): ResourceInteraction {
  const targetId: string = normalizedId(resourceId);
  if (targetId.length === 0) {
    return empty('');
  }
  for (let index: number = 0; index < interactions.length; index += 1) {
    if (normalizedId(interactions[index].resourceId) === targetId) {
      return copyInteraction(interactions[index]);
    }
  }
  return empty(targetId);
}

export function upsert(
  interactions: ResourceInteraction[],
  interaction: ResourceInteraction
): ResourceInteraction[] {
  const candidate: ResourceInteraction = copyInteraction(interaction);
  const output: ResourceInteraction[] = [];
  let inserted: boolean = false;

  for (let index: number = 0; index < interactions.length; index += 1) {
    const current: ResourceInteraction = copyInteraction(interactions[index]);
    if (current.resourceId.length === 0) {
      continue;
    }
    if (candidate.resourceId.length > 0 && current.resourceId === candidate.resourceId) {
      if (!inserted) {
        output.push(candidate);
        inserted = true;
      }
    } else {
      output.push(current);
    }
  }

  if (candidate.resourceId.length > 0 && !inserted) {
    output.push(candidate);
  }
  return output;
}

export function recordView(interaction: ResourceInteraction): ResourceInteraction {
  const result: ResourceInteraction = copyInteraction(interaction);
  if (result.resourceId.length > 0) {
    result.viewRecorded = true;
  }
  return result;
}

export function recordDownload(interaction: ResourceInteraction): ResourceInteraction {
  const result: ResourceInteraction = copyInteraction(interaction);
  if (result.resourceId.length > 0 && result.downloadCount < MAX_COUNTER) {
    result.downloadCount += 1;
  }
  return result;
}

export function toggleFavorite(interaction: ResourceInteraction): ResourceInteraction {
  const result: ResourceInteraction = copyInteraction(interaction);
  if (result.resourceId.length > 0) {
    result.favorite = !result.favorite;
  }
  return result;
}

export function rate(interaction: ResourceInteraction, score: number): ResourceInteraction {
  const result: ResourceInteraction = copyInteraction(interaction);
  if (result.resourceId.length > 0 && normalizedRating(score) > 0) {
    result.rating = score;
  }
  return result;
}

export function report(interaction: ResourceInteraction): ResourceInteraction {
  const result: ResourceInteraction = copyInteraction(interaction);
  if (result.resourceId.length > 0) {
    result.reported = true;
  }
  return result;
}

export function applyToResource(
  resource: KnowledgeResource,
  before: ResourceInteraction,
  after: ResourceInteraction
): KnowledgeResource {
  const result: KnowledgeResource = copyResource(resource);
  const resourceId: string = normalizedId(resource.id);
  if (resourceId.length === 0) {
    return result;
  }

  const previous: ResourceInteraction = interactionForResource(resourceId, before);
  const next: ResourceInteraction = interactionForResource(resourceId, after);
  const viewDelta: number = (next.viewRecorded ? 1 : 0) - (previous.viewRecorded ? 1 : 0);
  const favoriteDelta: number = (next.favorite ? 1 : 0) - (previous.favorite ? 1 : 0);
  const downloadDelta: number = next.downloadCount - previous.downloadCount;

  result.viewCount = Math.max(0, normalizedCounter(resource.viewCount) + viewDelta);
  result.downloadCount = Math.max(0, normalizedCounter(resource.downloadCount) + downloadDelta);
  result.favoriteCount = Math.max(0, normalizedCounter(resource.favoriteCount) + favoriteDelta);

  let ratingCount: number = normalizedCounter(resource.ratingCount);
  const baseAverage: number = Number.isFinite(resource.averageRating) ?
    Math.max(0, Math.min(5, resource.averageRating)) : 0;
  let ratingTotal: number = baseAverage * ratingCount;
  if (previous.rating > 0 && ratingCount > 0) {
    ratingCount -= 1;
    ratingTotal = Math.max(0, ratingTotal - previous.rating);
  }
  if (next.rating > 0) {
    ratingCount = Math.min(MAX_COUNTER, ratingCount + 1);
    ratingTotal += next.rating;
  }

  result.ratingCount = ratingCount;
  result.averageRating = ratingCount === 0 ? 0 :
    roundedRating(Math.max(0, Math.min(5, ratingTotal / ratingCount)));
  return result;
}
