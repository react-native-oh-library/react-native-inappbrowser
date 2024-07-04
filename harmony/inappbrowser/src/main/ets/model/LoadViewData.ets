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
import { Browser } from './Browser'
import { HashMap } from '@kit.ArkTS'

class ToolPone{
  id:number = 0
  imageSrc: Resource = $r('app.media.ic_public_back')
}


const toolPoneArray:ToolPone[] = [
  {
    imageSrc: $r('app.media.ic_public_back'),
    id: 1
  },
  {
    imageSrc: $r("app.media.ic_public_advance"),
    id: 2
  },
  {
    imageSrc: $r('app.media.ic_public_share'),
    id: 5
  },
  {
    imageSrc: $r('app.media.ic_public_browser'),
    id: 3
  }
]

const actionButton:ToolPone[] = [
  {
    imageSrc: $r('app.media.submit'),
    id: 5
  },
  {
    imageSrc: $r('app.media.ic_public_add'),
    id: 6
  },
]

export { toolPoneArray,ToolPone,actionButton}