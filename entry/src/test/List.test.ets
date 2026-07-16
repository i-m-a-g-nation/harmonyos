import localUnitTest from './LocalUnit.test';
import minePageTest from './MinePage.test';

export default function testsuite() {
  localUnitTest();
  minePageTest();
}
