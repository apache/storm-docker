#!/bin/bash

echo "importKeys() { \\"
echo "  for key in \\"
docker run --rm buildpack-deps:bullseye-curl bash -c 'curl -fsSL https://dist.apache.org/repos/dist/release/storm/KEYS | gpg --batch --import &> /dev/null && gpg --batch --list-keys --with-fingerprint --with-colons' |\
  awk -F: '$1 == "pub" && $2 == "-" { pub = 1 } pub && $1 == "fpr" { fpr = $10 } $1 == "sub" { pub = 0 } pub && fpr && $1 == "uid" && $2 == "-" { print "  #", $10; print "  " fpr " \\"; pub = 0 }'
echo "  ; do \\"
echo "    gpg --batch --keyserver hkps://keyserver.ubuntu.com--recv-keys \"\$key\" || \\"
echo "    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys \"\$key\" || \\"
echo "    gpg --batch --keyserver hkps://pgp.mit.edu --recv-keys \"\$key\" || \\"
echo "    gpg --batch --keyserver hkps://keyserver.pgp.com  --recv-keys \"\$key\" ; \\"
echo "  done; \\"
echo "}; \\"
