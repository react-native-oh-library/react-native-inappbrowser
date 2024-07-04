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
export class Constants {

  static readonly REQUEST_CODE = 200

  static readonly BROWSER_ABILITY_NAME = 'BrowserManagerAbility'

  static readonly ERROR_CODE = 'InAppBrowser';

  static readonly KEY_IS_DARK_COLOR = 'isDarkColor'
  //导航网址
  static readonly KEY_URL = 'url'
  //重定向网址
  static readonly KEY_REDIRECT_URL = 'redirectUrl'

  //设置关闭按钮的样式
  static readonly KEY_DISMISS_BUTTON_STYLE = 'dismissButtonStyle'
  static readonly KEY_IS_CLOSE_AUTH = 'isCloseAuth'

  //导航栏和工具栏的背景颜色
  static readonly KEY_PREFERRED_BAR_TINT_COLOR = 'preferredBarTintColor'
  //导航栏和工具栏上的控制按钮的着色颜色
  static readonly KEY_PREFERRED_CONTROL_TINT_COLOR = 'preferredControlTintColor'

  static readonly KEY_DEFAULT_RESULT_TYPE = 'dismiss'

  static readonly KEY_BROWSER_RESULT_TYPE = 'browserResultType'

  static readonly KEY_DISMISSED_EVENT = 'DismissedEvent'

  static readonly KEY_URL_TYPE_EVENT = 'TypeEvent'

  static readonly KEY_CLOSE_EVENT = 'CloseEvent'


  static readonly BUTTON_WIDTH ='22'
  static readonly BUTTON_RADIUS = 4;
  static readonly DOWN_COLOR = '#e4e4e4'
  static readonly UP_COLOR = '#00000000'
  static readonly PAD_USER_AGENT = 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_4_1 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Mobile/15E148 Safari/604.1'

  static readonly PHONE_USER_AGENT: string = 'HuaweiBrowser/12.0.4.1';
}

