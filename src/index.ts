import { registerPlugin } from '@capacitor/core';

import type { WorkoutkitPlugin } from './definitions';

const Workoutkit = registerPlugin<WorkoutkitPlugin>('Workoutkit', {
  web: () => import('./web').then((m) => new m.WorkoutkitWeb()),
});

export * from './definitions';
export { Workoutkit };
