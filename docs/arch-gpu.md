# Arch Linux: AUR helper and NVIDIA GPU

Host setup notes for the devhost. They are not applied by `make init`.

## yay (AUR helper)

```sh
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
yay --version
```

## NVIDIA drivers and CUDA

```sh
sudo pacman -Syu
sudo pacman -S nvidia-open nvidia-utils nvidia-settings cuda
nvidia-smi   # verify
```

cuDNN can be installed from the AUR if needed.

## Docker with GPU support

```sh
yay -S nvidia-container-toolkit
sudo systemctl restart docker
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi
```
