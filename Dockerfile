# 使用轻量 JRE
FROM eclipse-temurin:17-jre


RUN groupadd -g 1001 appgroup && \
    useradd -r -u 1001 -g appgroup appuser

WORKDIR /app


ENV TZ=Asia/Shanghai
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /var/lib/apt/lists/*


COPY target/InfinteChat-Agent-0.0.1-SNAPSHOT.jar app.jar


COPY src/main/resources/docs/ /init-docs/


RUN mkdir -p /data/docs


RUN chown -R appuser:appgroup /app /init-docs /data

USER appuser

EXPOSE 10010

VOLUME /tmp


ENTRYPOINT ["sh", "-c", "echo 'Current User:' $(whoami) && echo 'Copying docs...' && cp -rn /init-docs/* /data/docs/ && ls -l /data/docs/ && exec java $JAVA_OPTS -jar /app/app.jar"]