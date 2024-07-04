/**
 * MIT License
 *
 * Copyright (C) 2024 Huawei Device Co., Ltd.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import { TM } from '@rnoh/react-native-openharmony/generated/ts';
import { Constants } from './constants/Constants';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import Logger from './utils/Logger';
import emitter from '@ohos.events.emitter';
import { BrowserUrlEvent } from './model/BrowserUrlEvent';
import { BrowserDismissesEvent } from './model/BrowserDismissedEvent';
import { colorUtils } from './utils/ColorUtils';
import web_webview from '@ohos.web.webview';
const TAG: string = '[RNInAppBrowser]';

export default class RNInAppBrowser {

  private mOpened:boolean = false;
  private isLightTheme:Boolean = false;
  private static _inAppBrowser:RNInAppBrowser;
  private isInitialize:boolean = false

  public static getInstance():RNInAppBrowser {
    if (this._inAppBrowser == null) {
      this._inAppBrowser = new RNInAppBrowser();
    }
    return this._inAppBrowser;
  }

  open(options: TM.RNInAppBrowser.BrowserOptions,context: common.UIAbilityContext): Promise<TM.RNInAppBrowser.BrowserResult | TM.RNInAppBrowser.AuthSessionResult>{
    return new Promise((resolve,reject) => {
      if(this.mOpened) {
        let browserResult:TM.RNInAppBrowser.BrowserResult = {
          'type':"cancel",
        }
        this.mOpened = false;
        return resolve(browserResult);
      }
      const url = options.url? options.url : '';
      AppStorage.setOrCreate(Constants.KEY_URL, url);
      const redirectUrl = options.redirectUrl ? options.redirectUrl : '';
      AppStorage.setOrCreate(Constants.KEY_REDIRECT_URL,redirectUrl)
      const dismissButtonStyle = options.dismissButtonStyle ?  options.dismissButtonStyle : context.resourceManager.getStringByNameSync('page_done');
      AppStorage.setOrCreate(Constants.KEY_DISMISS_BUTTON_STYLE,dismissButtonStyle)
      let preferredBarTintColor = options.preferredBarTintColor ? options.preferredBarTintColor : context.resourceManager.getColorByNameSync('white');
      AppStorage.setOrCreate(Constants.KEY_PREFERRED_BAR_TINT_COLOR,preferredBarTintColor)
      this.isLightTheme = this.toolbarIsLight(preferredBarTintColor as number);
      AppStorage.setOrCreate(Constants.KEY_IS_DARK_COLOR,this.isLightTheme);
      const preferredControlTintColor = options.preferredControlTintColor? options.preferredControlTintColor : context.resourceManager.getColorByNameSync('blue');
      AppStorage.setOrCreate(Constants.KEY_PREFERRED_CONTROL_TINT_COLOR,preferredControlTintColor)
      let bundleName = context.abilityInfo.bundleName;
      let want: Want = {
        "bundleName": bundleName,
        "abilityName": "BrowserManagerAbility",
      }
      try{
        context.startAbility(want, (err: BusinessError) => {
          if(err.code) {
            reject(`startAbility failed, code is ${err.code}, message is ${err.message}`)
          }
          this.mOpened = true;
        })
      } catch (error) {
        Logger.error(TAG,`startAbility failed, code is ${error.code}, message is ${error.message}`);
        this.mOpened = false;
      }
      emitter.once(Constants.KEY_URL_TYPE_EVENT,(data:emitter.EventData) => {
        let browserData = data.data as BrowserUrlEvent;
        this.mOpened = false;
        let authSessionResult:TM.RNInAppBrowser.AuthSessionResult = {"type":browserData.resultType};
        if(browserData.url) {
          authSessionResult.url = browserData.url;
        }
        resolve(authSessionResult);
      })
      emitter.once(Constants.KEY_DISMISSED_EVENT,(data:emitter.EventData) => {
        let browserData = data.data as BrowserDismissesEvent;
        this.mOpened = false;
        if(browserData.isError) {
          // 判断是否存在错误
          return reject(browserData.message);
        } else {
          let browserResult:TM.RNInAppBrowser.BrowserResult = {
            'type':browserData.resultType,
            'message':browserData.message
          }
          return resolve(browserResult);
        }
      })
    });
  }

  close() {
    if(!this.mOpened) {
      return;
    }
    AppStorage.setOrCreate(Constants.KEY_IS_CLOSE_AUTH,true);
    emitter.emit(Constants.KEY_CLOSE_EVENT);
  }

  start() {
    web_webview.WebviewController.initializeWebEngine();
    let mostLikelyUrl:string = AppStorage.get('mostLikelyUrl') as string;
    console.info(TAG,'mostLikelyUrl =====' + mostLikelyUrl)
    let otherUrls:string[] = AppStorage.get('otherUrls') as string[];
    console.info(TAG,'otherUrls =====' + otherUrls)
    if(mostLikelyUrl) {
      web_webview.WebviewController.prepareForPageLoad(mostLikelyUrl, true, 2);
    }
    if(otherUrls && otherUrls.length > 0) {
      otherUrls.forEach((url:string) => {
        web_webview.WebviewController.prepareForPageLoad(url, true, 2);
      })
    }
    this.isInitialize = true;
  }

  warmup(): Promise<boolean> {
    return Promise.resolve(this.isInitialize);
  }

  toolbarIsLight(themeColor:number){
    return colorUtils.isDarkColor(themeColor)
  }

  mayLaunchUrl(mostLikelyUrl: string, otherUrls: string[]): void {
    AppStorage.setOrCreate('mostLikelyUrl',mostLikelyUrl);
    AppStorage.setOrCreate('otherUrls',otherUrls);
  }
}
