import cv2
import numpy
from PIL import Image

def main(Path):
    rgbImage = cv2.imread(Path)
    avg_color_per_row = numpy.average(rgbImage, axis=0)
    avg_color = numpy.average(avg_color_per_row, axis=0)
    intensity = (avg_color[2]+avg_color[1]+avg_color[0])/3
    #final=[]
    #final.append("{0:.3f}".format(avg_color[2]))
    #final.append("{0:.3f}".format(avg_color[1]))
    #final.append("{0:.3f}".format(avg_color[0]))
    #final.append("{0:.3f}".format(intensity))
    #print(final)
    finalStr=str("{0:.3f}".format(avg_color[2]))+" "+str("{0:.3f}".format(avg_color[1]))+" "+str("{0:.3f}".format(avg_color[0]))+" "+str("{0:.3f}".format(intensity));
    return finalStr
    #print(avg_color)