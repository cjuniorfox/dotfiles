#/bin/bash
RELEASE=39
TAR=Fedora-Container-Base-39-1.5.x86_64.tar.xz
CHECKSUM=Fedora-Container-39-1.5-x86_64-CHECKSUM
MIRROR='http://fedora.c3sl.ufpr.br/linux/releases'
MNT=/mnt
curl --fail-early --fail -L \
${MIRROR}/${RELEASE}/Container/x86_64/images/${TAR} \
-o rootfs.tar.gz
curl --fail-early --fail -L \
${MIRROR}/${RELEASE}/Container/x86_64/images/${CHECKSUM} \
-o checksum

grep 'Container-Base' checksum \
| grep '^SHA256' \
| sed -E 's|.*= ([a-z0-9]*)$|\1  rootfs.tar.gz|' > ./sha256checksum

sha256sum -c ./sha256checksum

rootfs_tar=$(tar t -af rootfs.tar.gz | grep layer.tar)
rootfs_tar_dir=$(dirname "${rootfs_tar}")
tar x -af rootfs.tar.gz "${rootfs_tar}"
ln -s "${MNT}" "${MNT}"/"${rootfs_tar_dir}"
tar x  -C "${MNT}" -af "${rootfs_tar}"
unlink "${MNT}"/"${rootfs_tar_dir}"

