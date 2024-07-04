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
import web_webview from '@ohos.web.webview'

export class WebObject {
  controller: WebviewController;
  isRegistered: boolean;
  constructor(controller: WebviewController, isRegistered: boolean) {
    this.controller = controller
    this.isRegistered = isRegistered
  }
}

@Observed
export class WebKey {
  key: number;
  timestamp: number;

  constructor(key: number, timestamp: number) {
    this.key = key
    this.timestamp = timestamp
  }
}

export enum LoadingStatus {
  LOADING,
  END
}

export class Browser {
  hostUrlName:string = ""
  redirectUrl:string = ""
  inputValue: string = ""
  resultUrl:string = ""
  receiveTitle:string = ''
  tabArrayIndex: number = 0
  progress: number = 0
  hideProgress: boolean = true
  accessBackward:boolean = false;
  accessForward:boolean = false;
  loadingStatus: LoadingStatus = LoadingStatus.END
  webArray: Array<WebKey> = [new WebKey(0, new Date().getTime())]
  tabsController: TabsController = new TabsController()
  webControllerArray: Array<WebObject> = [new WebObject(new web_webview.WebviewController(), false)]

  getWebArray() {
    return this.webArray
  }

  setTabArrayIndex(tabArrayIndex: number) {
    this.tabArrayIndex = tabArrayIndex
  }

  getTabArrayIndex() {
    return this.tabArrayIndex
  }

  setInputVal(inputValue: string) {
    this.inputValue = inputValue
  }

  getInputVal() {
    return this.inputValue
  }

  setRedirectUrl(redirectUrl:string) {
    this.redirectUrl = redirectUrl;
  }

  getRedirectUrl() {
    return this.redirectUrl;
  }

  Back() {
    if(this.webControllerArray[this.tabArrayIndex].controller.accessBackward()) {
      this.webControllerArray[this.tabArrayIndex].controller.backward();
    }
  }

  isBack() {
    return this.webControllerArray[this.tabArrayIndex].controller.accessBackward()
  }

  isFroward() {
    return this.webControllerArray[this.tabArrayIndex].controller.accessForward()
  }

  Forward() {
    if(this.webControllerArray[this.tabArrayIndex].controller.accessForward()) {
      this.webControllerArray[this.tabArrayIndex].controller.forward()
    }
  }

  Refresh() {
    this.webControllerArray[this.tabArrayIndex].controller.refresh()
  }

}
