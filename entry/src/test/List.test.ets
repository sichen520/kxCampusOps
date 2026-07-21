import dateTimeTest from './DateTime.test';
import feedbackQueueTest from './FeedbackQueue.test';
import knowledgeInteractionsTest from './KnowledgeInteractions.test';
import localUnitTest from './LocalUnit.test';
import recruitmentDiscoveryTest from './RecruitmentDiscovery.test';

export default function testsuite() {
  localUnitTest();
  knowledgeInteractionsTest();
  feedbackQueueTest();
  dateTimeTest();
  recruitmentDiscoveryTest();
}
