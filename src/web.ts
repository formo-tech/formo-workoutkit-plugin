import { WebPlugin } from '@capacitor/core';

import type { CreatePlannedWorkoutOptions, CreatePlannedWorkoutResult, WorkoutkitPlugin } from './definitions';

export class WorkoutkitWeb extends WebPlugin implements WorkoutkitPlugin {
  async createPlannedWorkout(_options: CreatePlannedWorkoutOptions): Promise<CreatePlannedWorkoutResult> {
    // WorkoutKit is only available on iOS 17+
    throw this.unavailable('WorkoutKit is only available on iOS 17+');
  }
}
