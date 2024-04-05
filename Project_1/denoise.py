import matplotlib.pyplot as plt
import numpy as np
import cv2
from scipy.signal import convolve2d
from scipy.ndimage import median_filter

def mynoisegen(type, m, n, param1=None, param2=None):
    if type.lower() == 'uniform':
        if param1 is None:
            param1 = -1
        if param2 is None:
            param2 = 1
        noise = param1 + (param2 - param1) * np.random.rand(m, n)
    elif type.lower() == 'gaussian':
        if param1 is None:
            param1 = 0
        if param2 is None:
            param2 = 1
        noise = param1 + np.sqrt(param2) * np.random.randn(m, n)
    elif type.lower() == 'saltpepper':
        if param1 is None:
            param1 = 0.5
        if param2 is None:
            param2 = 1
        noise = np.ones((m, n)) * 0.5
        nn = np.random.rand(m, n)
        noise[nn <= param1] = 0
        noise[(nn > param1) & (nn <= param1 + param2)] = 1
    else:
        raise ValueError('Unknown noise type.')
    return noise


def show_grayscale_image(img, title):
    plt.imshow(img, cmap='gray')
    plt.xlabel('x')
    plt.ylabel('y')
    plt.title(title)
    plt.show()


def save_as_svg(img, filename):
    plt.imshow(img, cmap='gray')
    plt.axis('off')
    plt.gca().set_position([0, 0, 1, 1])
    plt.savefig(filename + '.svg', format='svg', bbox_inches='tight')
    plt.show()


def generate_noisy_images(save_img=False, show_imgs=False, save_histograms=False):
    img = cv2.imread('./images/lena512.bmp', cv2.IMREAD_GRAYSCALE)

    # Gaussian image
    im_gauss = img + mynoisegen('gaussian', 512, 512, 0, 64)

    # Salty and peppery image
    im_saltp = np.array(img)
    n = mynoisegen('saltpepper', 512, 512, .05, .05)
    im_saltp[n == 0] = 0
    im_saltp[n == 1] = 255

    if save_img:
        save_as_svg(img, 'original.svg')
        save_as_svg(im_gauss, 'gaussian.svg')
        save_as_svg(im_saltp, 'salt_and_pepper.svg')

    if show_imgs:
        show_grayscale_image(img, 'Original image')
        show_grayscale_image(im_gauss, 'Gaussian noise')
        show_grayscale_image(im_saltp, 'Salt and pepper noise')

    if save_histograms is not None:
        save_histogram(img, 'original_hist')
        save_histogram(im_gauss, 'gaussian_noise_hist')
        save_histogram(im_saltp, 'salt_pepper_hist')
    return im_gauss, im_saltp


def apply_filter(img, filter_name: str, result_filename=None, histogram_filename=None):
    mean_filter = np.ones((3, 3)) / 9
    if filter_name == 'mean':
        result = convolve2d(img, mean_filter, mode='same')
    elif filter_name == 'median':
        result = median_filter(img, size=3)
    else:
        raise NameError("not a valid filter name")
    if result_filename is not None:
        save_as_svg(result, result_filename)
    if histogram_filename is not None:
        save_histogram(result, histogram_filename)
    return result


def save_histogram(image_matrix, filename):
    plt.hist(image_matrix.flatten(), range=(0, 256), bins=256)
    plt.xlabel('r')
    plt.ylabel('h(r)')
    plt.savefig(filename + '.png', bbox_inches='tight')
    plt.show()


np.random.seed(42)
gaus_img, salpep_img = generate_noisy_images(save_img=False, show_imgs=False, save_histograms=True)

res1 = apply_filter(gaus_img, 'mean', result_filename="mean_gaussian", histogram_filename='mean_gaus_hist')
res2 = apply_filter(gaus_img, 'median', result_filename="median_gaussian", histogram_filename='median_gaus_hist')
res3 = apply_filter(salpep_img, 'mean', result_filename="mean_salt_pepper", histogram_filename='mean_salt_pepper_hist')
res4 = apply_filter(salpep_img, 'median', result_filename="median_salt_pepper", histogram_filename='median_salt_pepper_hist')

