FROM --platform=${TARGETPLATFORM} liferay/jdk11:latest

ARG LABEL_BUILD_DATE
ARG LABEL_JOB_RUNNER_VERSION
ARG LABEL_NAME
ARG LABEL_VCS_REF
ARG LABEL_VCS_URL
ARG LABEL_VERSION
ARG TARGETPLATFORM

RUN apt-get install cron && \
	apt-get clean

COPY scripts/* /usr/local/bin/

ENTRYPOINT ["tini", "-v", "--", "/usr/local/bin/liferay_job_runner_entrypoint.sh"]

LABEL org.label-schema.build-date="${LABEL_BUILD_DATE}"
LABEL org.label-schema.job-runner-version="${LABEL_JOB_RUNNER_VERSION}"
LABEL org.label-schema.name="${LABEL_NAME}"
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.vcs-ref="${LABEL_VCS_REF}"
LABEL org.label-schema.vcs-url="${LABEL_VCS_URL}"
LABEL org.label-schema.vendor="Liferay, Inc."
LABEL org.label-schema.version="${LABEL_VERSION}"

WORKDIR /opt/liferay