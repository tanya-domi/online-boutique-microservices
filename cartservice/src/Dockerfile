FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0.100-noble@sha256:c7445f141c04f1a6b454181bd098dcfa606c61ba0bd213d0a702489e5bd4cd71 AS builder
ARG TARGETARCH
WORKDIR /app
COPY cartservice.csproj .
RUN dotnet restore cartservice.csproj \
    -a $TARGETARCH
COPY . .
RUN dotnet publish cartservice.csproj \
    -p:PublishSingleFile=true \
    -a $TARGETARCH \
    --self-contained true \
    -p:PublishTrimmed=true \
    -p:TrimMode=full \
    -c release \
    -o /cartservice

# https://mcr.microsoft.com/product/dotnet/runtime-deps
FROM mcr.microsoft.com/dotnet/runtime-deps:10.0.0-noble-chiseled@sha256:b857c8cb8d929183cfe4c6dd9994abba92a2639dd2dbaf06005379f815991604

WORKDIR /app
COPY --from=builder /cartservice .
EXPOSE 7070
ENV DOTNET_EnableDiagnostics=0 \
    ASPNETCORE_HTTP_PORTS=7070
USER 1000
ENTRYPOINT ["/app/cartservice"]


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


# # Build stage
# FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0.101-noble AS builder
# ARG TARGETARCH
# WORKDIR /app
# COPY cartservice.csproj .
# RUN dotnet restore cartservice.csproj -a $TARGETARCH
# COPY . .
# RUN dotnet publish cartservice.csproj \
#     -a $TARGETARCH \
#     -c Release \
#     -o /cartservice

# # Runtime stage
# FROM mcr.microsoft.com/dotnet/aspnet:9.0.1-noble
# WORKDIR /app
# COPY --from=builder /cartservice .

# # OpenTelemetry auto-instrumentation
# USER root
# ARG OTEL_VERSION=1.11.0
# ADD https://github.com/open-telemetry/opentelemetry-dotnet-instrumentation/releases/download/v${OTEL_VERSION}/otel-dotnet-auto-install.sh otel-dotnet-auto-install.sh
# RUN apt-get update && apt-get install -y curl unzip && \
#     OTEL_DOTNET_AUTO_HOME=/otel-dotnet-auto sh otel-dotnet-auto-install.sh && \
#     rm -rf /var/lib/apt/lists/*

# ENV DOTNET_STARTUP_HOOKS=/otel-dotnet-auto/net/OpenTelemetry.AutoInstrumentation.StartupHook.dll
# ENV CORECLR_ENABLE_PROFILING=1
# ENV CORECLR_PROFILER={918728DD-259F-4A6A-AC2B-B85E1B658318}
# ENV CORECLR_PROFILER_PATH=/otel-dotnet-auto/linux-x64/OpenTelemetry.AutoInstrumentation.Native.so
# ENV ASPNETCORE_HTTP_PORTS=7070

# USER 1000
# EXPOSE 7070
# ENTRYPOINT ["dotnet", "cartservice.dll"]
