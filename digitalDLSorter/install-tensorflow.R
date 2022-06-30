reticulate::install_miniconda("/r-miniconda");
options(reticulate.conda_binary = "/r-miniconda/bin/conda");

reticulate::conda_create(envname = "digitaldlsorter-env", packages = "python==3.7.11")


