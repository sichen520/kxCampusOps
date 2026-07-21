import { common } from '@kit.AbilityKit';
import { fileIo, picker } from '@kit.CoreFileKit';

export enum AttachmentExportResult {
  SAVED = 'saved',
  CANCELLED = 'cancelled',
  FAILED = 'failed'
}

async function writeAll(file: fileIo.File, content: Uint8Array): Promise<boolean> {
  let offset: number = 0;
  try {
    while (offset < content.byteLength) {
      const chunk: ArrayBuffer = content.buffer.slice(
        content.byteOffset + offset, content.byteOffset + content.byteLength);
      const written: number = await fileIo.write(file.fd, chunk);
      if (written <= 0) {
        return false;
      }
      offset += written;
    }
  } catch (_error) {
    return false;
  }
  return true;
}

export async function exportBundledAttachment(
  context: common.UIAbilityContext,
  rawFileName: string,
  displayName: string
): Promise<AttachmentExportResult> {
  if (rawFileName.trim().length === 0 || displayName.trim().length === 0) {
    return AttachmentExportResult.FAILED;
  }
  try {
    const documentPicker: picker.DocumentViewPicker = new picker.DocumentViewPicker(context);
    const options: picker.DocumentSaveOptions = new picker.DocumentSaveOptions();
    options.newFileNames = [displayName];
    options.fileSuffixChoices = ['PDF|.pdf'];
    const targetUris: string[] = await documentPicker.save(options);
    if (targetUris.length === 0) {
      return AttachmentExportResult.CANCELLED;
    }

    const content: Uint8Array = await context.resourceManager.getRawFileContent(rawFileName);
    const targetFile: fileIo.File = await fileIo.open(
      targetUris[0], fileIo.OpenMode.WRITE_ONLY | fileIo.OpenMode.TRUNC);
    let saved: boolean = false;
    try {
      saved = await writeAll(targetFile, content);
    } finally {
      await fileIo.close(targetFile);
    }
    return saved ? AttachmentExportResult.SAVED : AttachmentExportResult.FAILED;
  } catch (_error) {
    return AttachmentExportResult.FAILED;
  }
}
