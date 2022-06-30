from setuptools import setup

setup(name='DeconUtils',
      version='0.1',
      description='Deconvolution utilities',
      url='#',
      author='Phi Hung Nguyen',
      author_email='hungnp@nevada.unr.edu',
      license='MIT',
      packages=['DeconUtils'],
      install_requires=[
            'numpy',
            'pandas',
            'h5py'
      ],
      zip_safe=False)
