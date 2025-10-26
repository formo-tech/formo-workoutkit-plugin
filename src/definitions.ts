export interface WorkoutkitPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
