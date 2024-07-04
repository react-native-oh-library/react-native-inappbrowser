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
import { Browser, LoadingStatus, WebKey,WebObject  } from '../model/Browser';
import Logger from '../utils/Logger';
import { Constants } from '../constants/Constants';
import { urlUtils } from '../utils/UrlUtils';
import common from '@ohos.app.ability.common';

const TAG: string = '[TitleBar]';


@Component
export struct WebTab {
  @Link browser: Browser;
  @Link isPhone: boolean;
  private isRegistered: boolean = false;

  build() {
    Tabs({ barPosition: BarPosition.Start, controller: this.browser.tabsController }) {
      ForEach(this.browser.webArray,(item:WebKey) => {
        TabContent() {
          Web({
            src:this.browser.inputValue,
            controller: this.browser?.webControllerArray[item.key]?.controller
          })
            .javaScriptAccess(true)
            .fileAccess(true)
            .onControllerAttached(() => {
              this.browser?.webControllerArray[item.key]?.controller.setCustomUserAgent(Constants.PAD_USER_AGENT)
            })
            .domStorageAccess(true)
            .onTitleReceive((event) => {
              this.browser.receiveTitle = event?.title as string;
            })
            .onLoadIntercept((event) => {
              if(this.isRegistered) {
                if(this.browser.getRedirectUrl() && event.data.getRequestUrl().startsWith(this.browser.getRedirectUrl())) {
                  this.browser.resultUrl = event.data.getRequestUrl();
                  AppStorage.setOrCreate(Constants.KEY_IS_CLOSE_AUTH,true);
                  this.isRegistered = false;
                  let context = getContext(this) as common.UIAbilityContext;
                  context.terminateSelf();
                  return true;
                }
              }
              this.isRegistered = event.data.isRedirect()
              return false
            })
            .onPageBegin((event) => {
              Logger.info(TAG, `onPageBegin= ${JSON.stringify(event)}`)
              if(event?.url.startsWith('http')) {
                this.browser.inputValue = event?.url;
                this.browser.hostUrlName = urlUtils.getHostName(event?.url);
              }  else {
                this.browser.inputValue = ''
                this.browser.hostUrlName = ''
              }
              this.browser.loadingStatus = LoadingStatus.LOADING;
            })
            .onPageEnd((event) => {
              Logger.info(TAG, `onPageEnd= ${JSON.stringify(event)}`)
              if (item.key < this.browser.webControllerArray.length && this.browser.webControllerArray[item.key]?.controller) {
                this.browser.loadingStatus = LoadingStatus.END;
                this.browser.accessBackward = this.browser.isBack();
                this.browser.accessForward = this.browser.isFroward();
              }
            })
            .onProgressChange((event) => {
              Logger.info(TAG, `onProgressChange`);
              this.browser.progress = event?.newProgress as number;
              if(!this.browser.inputValue){
                if(event?.newProgress !== 10) {
                  this.browser.progress = event?.newProgress as number;
                }
              } else {
                this.browser.progress = event?.newProgress as number;
              }
              if(this.browser.progress === 100) {
                this.browser.hideProgress = true;
                this.browser.progress = 0;
              } else {
                this.browser.hideProgress = false;
              }
            })
        }
      },(item:WebKey) => item.timestamp.toString())
    }
    .backgroundColor('#f3f3f3')
    .barHeight(0)
    .scrollable(false)
  }
}