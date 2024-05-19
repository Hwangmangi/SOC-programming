from PIL import Image
import os
import cv2
import numpy as np


# 이미지 파일 경로
os.chdir(r'C:\code\SOC-programming\img')
'''
# 원본 이미지 열기
img = Image.open('lv.jpg')

img_array = np.array(img)

# RGB565 형식으로 변환
r = ((img_array[:,:,0] >> 3) & 0x1F).astype(np.uint16)
g = ((img_array[:,:,1] >> 2) & 0x3F).astype(np.uint16)
b = ((img_array[:,:,2] >> 3) & 0x1F).astype(np.uint16)
rgb565 = (r << 11) | (g << 5) | b

# RGB565 형식으로 변환된 이미지 크기 설정
img_rgb565 = Image.fromarray(rgb565.astype(np.uint8))

# 원하는 해상도로 크롭 (480x272)
img_resized = img_rgb565.resize((480, 272))

# 저장
img_resized.save('output_image_rgb565.jpg')'''

img = Image.open(r'C:\code\SOC-programming\img\lv.jpg')

# RGB565 변환 함수 정의
def rgb_to_rgb565(r, g, b):
    # RGB565로 변환
    return ((r & 0xF8) << 8) | ((g & 0xFC) << 3) | (b >> 3)

# 이미지를 RGB565 배열로 변환
def image_to_rgb565(img):
    img = img.convert("RGB")
    width, height = img.size
    rgb565_data = []
    for y in range(height):
        for x in range(width):
            r, g, b = img.getpixel((x, y))
            rgb565 = rgb_to_rgb565(r, g, b)
            # 상위 8비트와 하위 8비트를 나눠서 리스트에 추가
            rgb565_data.append((rgb565 >> 8) & 0xFF)
            rgb565_data.append(rgb565 & 0xFF)
    return np.array(rgb565_data, dtype=np.uint8)

# RGB565 데이터 생성
rgb565_array = image_to_rgb565(img)

# 이진 파일(.bin)로 저장
output_bin_file = 'output_image_rgb565.bin'
with open(output_bin_file, 'wb') as f:
    f.write(rgb565_array)

print(f"RGB565 데이터를 {output_bin_file} 파일로 저장했습니다.")

input_bin_file = 'output_image_rgb565.bin'
with open(input_bin_file, 'rb') as f:
    rgb565_array = f.read()

# RGB565 데이터를 Pillow Image로 변환
def rgb565_to_image(rgb565_data, width, height):
    img = Image.new('RGB', (width, height))
    pixels = img.load()
    idx = 0
    for y in range(height):
        for x in range(width):
            # RGB565 데이터 추출
            rgb565 = (rgb565_data[idx] << 8) | rgb565_data[idx + 1]
            idx += 2
            # RGB565를 RGB로 변환
            r = (rgb565 >> 11) & 0x1F
            g = (rgb565 >> 5) & 0x3F
            b = rgb565 & 0x1F
            # 5비트에서 8비트로 확장
            r = (r << 3) | (r >> 2)
            g = (g << 2) | (g >> 4)
            b = (b << 3) | (b >> 2)
            # 이미지에 픽셀 적용
            pixels[x, y] = (r, g, b)
    return img

# RGB565 데이터를 이미지로 변환
img_rgb565 = rgb565_to_image(rgb565_array, 480, 272)

# 이미지 보기
img_rgb565.show()