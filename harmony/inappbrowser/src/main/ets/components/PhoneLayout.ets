/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Browser } from '../model/Browser';
import { ToolPone, toolPoneArray } from '../model/LoadViewData';
import { WebTab } from './TitleBar';
import common from '@ohos.app.ability.common';
import { Constants } from '../constants/Constants';
import { BrowserDismissesEvent } from '../model/BrowserDismissedEvent';
import emitter from '@ohos.events.emitter';
import { urlUtils } from '../utils/UrlUtils';
import { BrowserUrlEvent } from '../model/BrowserUrlEvent';
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';

@Component
export struct PhoneLayout {
  @Link browser: Browser;
  @State isPhone: boolean = true;
  @State message: string = 'done'
  @State hasDown: boolean = false;
  @State arrayIndex: number = 0;
  @State pageCount: string = '1';

  @StorageProp('dismissButtonStyle') cancel: string = '';
  @StorageProp('preferredBarTintColor') barColor: string = '';
  @StorageProp('preferredControlTintColor') tintColor: string  = '';
  @StorageProp('isDarkColor') isLightTheme:boolean = false;
  @StorageProp('url') url: string = '';
  @StorageProp('redirectUrl') redirectUrl:string = ''
  @StorageProp('isCloseAuth') isCloseAuth:boolean = false;

  @State dismissButton:string = '';
  private context = getContext(this) as common.UIAbilityContext;
  private toolPones:ToolPone[] = toolPoneArray;
  private resultType:string = '';

  aboutToAppear() {
    this.setDismissButtonStyle();
    this.setInputUrl();
    this.setRedirectUrl();
    this.setUrlName();
    this.onCloseAbility();
    this.resultType = Constants.KEY_DEFAULT_RESULT_TYPE
  }

  setDismissButtonStyle() {
    if (this.cancel === 'done') {
      this.dismissButton = getContext(this).resourceManager.getStringSync($r('app.string.page_done'))
    } else if (this.cancel === 'close'){
      this.dismissButton = getContext(this).resourceManager.getStringSync($r('app.string.page_close'))
    } else if(this.cancel === 'cancel') {
      this.dismissButton = getContext(this).resourceManager.getStringSync($r('app.string.page_cancel'))
    }
  }

  setInputUrl() {
    this.browser.setInputVal(this.url);
  }

  setRedirectUrl() {
    this.browser.setRedirectUrl(this.redirectUrl);
  }

  toBrowser() {
    this.context.startAbility({
      action:'ohos.want.action.viewData',
      uri:this.browser.inputValue,
      entities:["entity.system.browsable"]
    })
  }

  setUrlName() {
    this.browser.hostUrlName = urlUtils.getHostName(this.url)
  }

  dismissedAbility() {
    this.context.terminateSelf();
  }

  onCloseAbility() {
    emitter.once(Constants.KEY_CLOSE_EVENT,(data) => {
      this.dismissedAbility();
    })
  }

  onOffEvent() {
    emitter.off(Constants.KEY_CLOSE_EVENT);
  }

  toShare() {
    let data: systemShare.SharedData = new systemShare.SharedData({
      utd: utd.UniformDataType.HYPERLINK,
      title:this.browser.receiveTitle,
      description:this.browser.inputValue,
      content: this.browser.inputValue
    });
    let controller: systemShare.ShareController = new systemShare.ShareController(data);
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    controller.show(context, {
      previewMode: systemShare.SharePreviewMode.DETAIL,
      selectionMode: systemShare.SelectionMode.SINGLE
    });
  }

  @Builder
  TitleBar() {
    Column(){
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Start
      , alignItems: ItemAlign.Center }) {
        Text(this.dismissButton ? this.dismissButton : $r('app.string.page_done'))
          .fontSize(20)
          .fontColor(this.tintColor)
          .fontWeight(400)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            let context = getContext() as common.UIAbilityContext;
            this.resultType = "cancel";
            context.terminateSelf();
          })
        Row() {
           Image(this.isLightTheme ? $r('app.media.ic_public_white_lock'):$r("app.media.ic_public_blank_lock"))
             .width('16')
             .height('16')
             .margin({left:2,right:2})
             .fillColor(this.isLightTheme ? '#FFFFFF' :'#000000')
          Text(this.browser.hostUrlName).fontSize(20).textCase(TextCase.Normal).fontColor(this.isLightTheme ? '#FFFFFF' :'#000000')
        }
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        Image($r("app.media.ic_public_refresh"))
          .fillColor(this.tintColor)
          .width(25)
          .height(25)
          .onClick(() => {
            this.browser.Refresh();
          })
      }
      .padding({ left: 25, right: 25 })
      .backgroundColor(this.barColor)
      .width('100%')
      .height(63)
       Divider().color('#e9eaec')
      if(!this.browser.hideProgress) {
        Progress({ value: this.browser.progress, total: 100 })
          .color('#0000ff')
      }
    }
    .height('100%')
  }

  @Builder
  ToolBar() {
    Row() {
      ForEach(this.toolPones,(item:ToolPone,index:number) => {
        Column() {
          Divider().color('#e9eaec')
          Button({ type: ButtonType.Normal }) {
            Column() {
              if(item.id === 1) {
                Image(item.imageSrc)
                  .fillColor(this.browser.accessBackward ? this.tintColor : Constants.DOWN_COLOR)
              } else if(item.id === 2) {
                Image(item.imageSrc)
                  .fillColor(this.browser.accessForward ? this.tintColor : Constants.DOWN_COLOR)
              }  else {
                Image(item.imageSrc)
                  .fillColor(this.tintColor)
              }
            }
            .width(Constants.BUTTON_WIDTH)
            .height(Constants.BUTTON_WIDTH)
            .justifyContent(FlexAlign.Center)
          }
          .height('100%')
          .width('100%')
          .backgroundColor(this.arrayIndex === item.id ? Constants.DOWN_COLOR : Constants.UP_COLOR)
          .borderRadius(Constants.BUTTON_RADIUS)
          .flexShrink(0)
          .onTouch((event: TouchEvent) => {
            if(event.type === TouchType.Down) {
              this.arrayIndex = item.id
            } else if(event.type === TouchType.Up) {
              this.arrayIndex = 0;
            }
          })
          .onClick((event: ClickEvent) => {
            switch (item.id) {
              case 1:
                this.browser.Back()
                break;
              case 2:
                //TODO 下一个
                this.browser.Forward()
                break
              case 3:
                //跳转到华为浏览器
                this.toBrowser();
                break
              case 5:
                //TODO 分享
                this.toShare();
                break;
            }
          })
        }
        .width('20%')
        .id(`navigationButton${index}`)
      })
    }
    .justifyContent(FlexAlign.SpaceAround)
    .backgroundColor(this.barColor)
    .width('100%')
    .height('100%')
  }

  build() {
    Navigation() {
      WebTab({ browser: $browser, isPhone: $isPhone })
    }
    .title({ builder: this.TitleBar, height: 65 })
    .toolbarConfiguration(this.ToolBar)
    .hideBackButton(true)
  }

  aboutToDisappear(): void {
    let eventData: emitter.EventData = {};
    if(this.isCloseAuth) {
      eventData.data = new BrowserUrlEvent(this.browser.resultUrl ? 'success' : Constants.KEY_DEFAULT_RESULT_TYPE,this.browser.resultUrl);
      emitter.emit(Constants.KEY_URL_TYPE_EVENT,eventData)
    } else {
      eventData.data = new BrowserDismissesEvent(this.resultType === 'cancel' ? 'browser ability closed':'browser ability destroyed',this.resultType === 'cancel' ? this.resultType:Constants.KEY_DEFAULT_RESULT_TYPE,false);
      emitter.emit(Constants.KEY_DISMISSED_EVENT,eventData)
    }
    let arrayData = ['dismissButtonStyle','preferredBarTintColor','preferredControlTintColor'];
    AppStorage.setOrCreate('isDarkColor',false);
    AppStorage.setOrCreate('isCloseAuth',false);
    this.clearData(arrayData)
    this.onOffEvent();
    this.resultType = '';
  }

  clearData(arrayData : Array<string>) {
    for (let i = 0; i < arrayData.length; i++) {
      AppStorage.setOrCreate(arrayData[i], '');
    }
  }
}