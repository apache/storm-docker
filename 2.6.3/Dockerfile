FROM eclipse-temurin:11-jre

ENV STORM_CONF_DIR=/conf \
    STORM_DATA_DIR=/data \
    STORM_LOG_DIR=/logs

# Remove the default user 'ubuntu' and its group
RUN userdel -r ubuntu && \
    groupdel ubuntu || true \

# Add a user with an explicit UID/GID and create necessary directories
RUN set -eux; \
    groupadd -r storm --gid=1000; \
    useradd -r -g storm --uid=1000 storm; \
    mkdir -p "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"; \
    chown -R storm:storm "$STORM_CONF_DIR" "$STORM_DATA_DIR" "$STORM_LOG_DIR"``

# Install required packages
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        dirmngr \
        gosu \
        gnupg \
        python3 \
        procps \
        wget; \
    rm -rf /var/lib/apt/lists/*; \
# Verify that gosu binary works
    gosu nobody true

ARG DISTRO_NAME=apache-storm-2.6.3


# Download Apache Storm, verify its PGP signature, untar and clean up
RUN set -eux; \
    ddist() { \
        local f="$1"; shift; \
        local distFile="$1"; shift; \
        local success=; \
        local distUrl=; \
        for distUrl in \
            'https://www.apache.org/dyn/closer.cgi?action=download&filename=' \
            https://www-us.apache.org/dist/ \
            https://www.apache.org/dist/ \
            https://archive.apache.org/dist/ \
        ; do \
            if wget -q -O "$f" "$distUrl$distFile" && [ -s "$f" ]; then \
                success=1; \
                break; \
            fi; \
        done; \
        [ -n "$success" ]; \
    }; \
    # Generated via automation/create-key-section.sh
    importKeys() { \
      for key in \
      # Meng Li (Ethan Li CODE SIGNING KEY) <ethanli@apache.org>
      5167DE337E7370373499FC1DA4A672F11B5050C8 \
      # Kishorkumar Vasantrao Patil (CODE SIGNING KEY) <kishorvpatil@apache.org>
      32C8C0BEE3D01AF46B6E24B0AC30BFA8FEF0711F \
      # Govind Rajagopal Menon (Release Signing Key) <govind@apache.org>
      79B03D059E628478FC9F1D8B152CAD0C46E87B61 \
      # Bipin Prasad (For Signing Apache Storm release) <bipinprasad@apache.org>
      51379DA8A7AE5B02674EF15C134716AF768D9B6E \
      # Aaron Gresch <agresch@apache.org>
      DA903F2CF9BBD42EAECFA9E45EA6FAEF09A4474D \
      # Kishor Patil (The keys for signing Storm releases) <kishorvpatil@apache.org>
      6156BAC0C21A1991CF1B690AB2973D6F4A67943A \
      # Richard Zowalla (Code Signing Key) <rzo1@apache.org>
      B83D15E72253ED1104EB4FBBDAB472F0E5B8A431 \
      # Richard Zowalla (GitHub) <rzo1@apache.org>
      339F3B2F72129ABCA81D96DA91EA7956A2DAD9CE \
      # Rui Abreu (Code Signing Key) <rabreu@apache.org>
      72B436558AA9CDCA2C4CBAC340D4B35E2C1452E5 \
      ; do \
        gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || \
        gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
        gpg --batch --keyserver hkps://pgp.mit.edu --recv-keys "$key" || \
        gpg --batch --keyserver hkps://keyserver.pgp.com --recv-keys "$key" ; \
      done; \
    }; \
    ddist "$DISTRO_NAME.tar.gz" "storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    ddist "$DISTRO_NAME.tar.gz.asc" "storm/$DISTRO_NAME/$DISTRO_NAME.tar.gz.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    importKeys; \
    gpg --batch --verify "$DISTRO_NAME.tar.gz.asc" "$DISTRO_NAME.tar.gz"; \
    tar -xzf "$DISTRO_NAME.tar.gz"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz" "$DISTRO_NAME.tar.gz.asc"; \
    chown -R storm:storm "$DISTRO_NAME"

WORKDIR $DISTRO_NAME

ENV PATH $PATH:/$DISTRO_NAME/bin

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
