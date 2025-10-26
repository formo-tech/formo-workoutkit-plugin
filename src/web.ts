import { WebPlugin } from '@capacitor/core';

import type { WorkoutkitPlugin } from './definitions';

export class WorkoutkitWeb extends WebPlugin implements WorkoutkitPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
