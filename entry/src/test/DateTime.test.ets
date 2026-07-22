import { describe, expect, it } from '@ohos/hypium';
import { formatLocalMinute } from '../main/ets/shared/DateTime';

export default function dateTimeTest() {
  describe('dateTime', () => {
    it('formatsLocalTimeToMinutePrecision', 0, () => {
      const date: Date = new Date(2026, 6, 2, 3, 4, 59);
      expect(formatLocalMinute(date)).assertEqual('2026-07-02 03:04');
    });
  });
}
