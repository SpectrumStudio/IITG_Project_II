import cv2
import numpy
from PIL import Image

def main(Path):
    rgbImage = cv2.imread(Path)
    avg_color_per_row = numpy.average(rgbImage, axis=0)
    avg_color = numpy.average(avg_color_per_row, axis=0)
    intensity = (avg_color[2]+avg_color[1]+avg_color[0])/3
    final=[]
    final.append(avg_color[2])
    final.append(avg_color[1])
    final.append(avg_color[0])
    final.append(intensity)
    print(final)
    return final
    #print(avg_color)