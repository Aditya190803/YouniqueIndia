// Minimal Node.js and package type shims to allow compiling without @types/node
export {};

declare global {
  // Minimal Process with env only
  // eslint-disable-next-line @typescript-eslint/no-namespace
  namespace NodeJS {
    interface ProcessEnv {
      [key: string]: string | undefined;
    }
  }
}

declare const process: { env: NodeJS.ProcessEnv };
declare const Buffer: any;

declare module 'crypto' {
  const anyExport: any;
  export = anyExport;
}

declare module 'path' {
  const anyExport: any;
  export = anyExport;
}

declare module 'fs' {
  const anyExport: any;
  export = anyExport;
}

declare module 'stream' {
  const anyExport: any;
  export = anyExport;
}

declare module 'http' {
  const anyExport: any;
  export = anyExport;
}

declare module 'https' {
  const anyExport: any;
  export = anyExport;
}

declare module 'url' {
  const anyExport: any;
  export = anyExport;
}

