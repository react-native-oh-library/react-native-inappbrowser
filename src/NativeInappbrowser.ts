import { TurboModuleRegistry, RootTag } from 'react-native';
import type { TurboModule } from 'react-native/Libraries/TurboModule/RCTExport';
/**
 * Codegen restriction: All TypeScript interfaces extending TurboModule must be called 'Spec'.
 */

export type BrowserOptions = {url: string, redirectUrl?:string,dismissButtonStyle?: string, preferredBarTintColor?: string, preferredControlTintColor?: string, animated?: boolean, modalEnabled?: boolean, readerMode?: boolean, enableBarCollapsing?: boolean}
  
export type BrowserResult = {type: string ,message?:string}

export type AuthSessionResult = {type: string,url?:string}

export type InAppBrowserOptions = {
  dismissButtonStyle?: string, preferredBarTintColor?: string, preferredControlTintColor?: string, animated?: boolean, modalEnabled?: boolean, readerMode?: boolean, enableBarCollapsing?: boolean,ephemeralWebSession?:boolean
}

export type InAppBrowserHarmonyOptions = {
  dismissButtonStyle?: 'done' | 'close' | 'cancel',
  preferredBarTintColor?: string,
  preferredControlTintColor?: string,
  animated?:boolean,
  modalEnabled?:boolean,
  readerMode?:boolean,
  enableBarCollapsing?:boolean
}

export interface Spec extends TurboModule {
  open(options: BrowserOptions): Promise<BrowserResult>;
  openAuth(url: string,redirectUrl: string,options?: InAppBrowserOptions): Promise<AuthSessionResult>;
  close(): void;
  warmup(): Promise<boolean>;
  mayLaunchUrl(mostLikelyUrl: string,otherUrls: string[]): void
  closeAuth(): void ;
  isAvailable(): Promise<boolean>;
}

export default TurboModuleRegistry.get<Spec>('RNInAppBrowser')!;
