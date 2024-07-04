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
const colorNameToHexMap =  {
  'white': '#FFFFFF',
  'black':'#000000',
  'blue':'#0000FF',
  'red':'#FF0000',
  'green':'#00FF00',
  'yellow':'#FFFF00',
  'cyan':'#00FFFF',
  'brown':'#A52A2A',
  'pink':'#FFC0CB',
  'gray':'#808080',
  'orange':'#FFA500',
  'purple':'#800080',
  'silver':'#C0C0C0',
  'magenta':'#FF00FF',
}

class ColorUtils {

  isDarkColor(colorInt:number) {
    const rgbValue = colorInt & 0xFFFFFF;
    const red = (rgbValue >> 16) & 0xFF;
    const green = (rgbValue >> 8) & 0xFF;
    const blue = rgbValue & 0xFF;
    // 计算亮度
    var brightness = this.calculateBrightness(red,green,blue);
    // 判断亮度是否低于某个阈值（例如0.5），如果是，则认为是深色
    return brightness < 0.5;
  }

  calculateBrightness(red, green, blue) {
    return (0.299 * red + 0.587 * green + 0.114 * blue) / 255;
  }

  getHexColor(colorName:string){
    if(this.isValidHexColor) {
      return colorName;
    }
    if(this.isValidARGBColor(colorName)) {
      return colorName;
    }
    return colorNameToHexMap[colorName.toLowerCase()] || '#FFFFFF';
  }

  isValidHexColor(hex) {
    // 如果不是 "#AARRGGBB" 格式，这里可以添加其他格式的检查（如 "rgba(...)"）
    const hexPattern = /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/;
    return hexPattern.test(hex);
  }

  isValidARGBColor(hex) {
    if (hex.startsWith('#') && hex.length === 9) {
      const hexParts = hex.slice(1).split('');
      for (let i = 0; i < hexParts.length; i++) {
        if (!/[0-9A-Fa-f]/.test(hexParts[i])) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
export const colorUtils = new ColorUtils();
