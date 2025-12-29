# Copyright 2021 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# https://mcr.microsoft.com/product/dotnet/sdk
# FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0.101-noble@sha256:1f13e67d295e02abdfd187c341f887442bad611eda536766172ced401fc8b9fa AS builder
# ARG TARGETARCH
# WORKDIR /app
# COPY cartservice.csproj .
# RUN dotnet restore cartservice.csproj \
#     -a $TARGETARCH
# COPY . .
# RUN dotnet publish cartservice.csproj \
#     -p:PublishSingleFile=true \
#     -a $TARGETARCH \
#     --self-contained true \
#     -p:PublishTrimmed=true \
#     -p:TrimMode=full \
#     -c release \
#     -o /cartservice

# # https://mcr.microsoft.com/product/dotnet/runtime-deps
# FROM mcr.microsoft.com/dotnet/runtime-deps:9.0.1-noble-chiseled@sha256:6f7466eda39e24efaf7eab2325e15d776a685d13cc93b4ea0cde9ee4f7982210

# WORKDIR /app
# COPY --from=builder /cartservice .
# EXPOSE 7070
# ENV DOTNET_EnableDiagnostics=0 \
#     ASPNETCORE_HTTP_PORTS=7070
# USER 1000
# ENTRYPOINT ["/app/cartservice"]

#Stage 1: Build App
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0-noble AS builder
ARG TARGETARCH
WORKDIR /app
COPY cartservice.csproj .
RUN dotnet restore cartservice.csproj -a $TARGETARCH
COPY . .
RUN dotnet publish cartservice.csproj -c release -o /cartservice -a $TARGETARCH

# Stage 2: Download OTel Agent
FROM alpine:latest AS otel-downloader
ARG OTEL_VERSION=1.11.0
WORKDIR /otel
RUN apk add --no-cache curl tar
# Download for Linux x64 (Standard GKE Node)
RUN curl -L https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/opentelemetry-dotnet-instrumentation-linux-x64.tar.gz -o otel.tar.gz && \
    mkdir /otel-dotnet-auto && \
    tar -xzf otel.tar.gz -C /otel-dotnet-auto

# Stage 3: Final Chiseled Runtime
FROM mcr.microsoft.com/dotnet/runtime-deps:9.0-noble-chiseled AS runtime
WORKDIR /app
COPY --from=builder /cartservice .
# Copy OTel files from downloader
COPY --from=otel-downloader /otel-dotnet-auto /otel-dotnet-auto

# OTel Environment Variables for .NET
ENV CORECLR_ENABLE_PROFILING="1" \
    CORECLR_PROFILER="{846759BB-039D-4184-B97C-2234605799E9}" \
    CORECLR_PROFILER_PATH="/otel-dotnet-auto/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so" \
    DOTNET_STARTUP_HOOKS="/otel-dotnet-auto/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll" \
    OTEL_DOTNET_AUTO_HOME="/otel-dotnet-auto" \
    OTEL_SERVICE_NAME="cartservice" \
    OTEL_EXPORTER_OTLP_ENDPOINT="http://otel-collector.grafana.svc.cluster.local:4317" \
    OTEL_TRACES_EXPORTER="otlp" \
    OTEL_METRICS_EXPORTER="otlp" \
    OTEL_LOGS_EXPORTER="otlp"

USER 1000

ENTRYPOINT ["/app/cartservice"]
