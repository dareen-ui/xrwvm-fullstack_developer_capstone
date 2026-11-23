# Single-container deployment of the Best Cars Dealership app (for Render).
# Runs: Django (public port), Node/Express dealers & reviews API with a local
# MongoDB, and the Flask sentiment analyzer.

# ---- Stage 1: build the React frontend ----
FROM node:20-bookworm-slim AS frontend
WORKDIR /app/frontend
COPY server/frontend/package*.json ./
RUN npm install --no-audit --no-fund
COPY server/frontend/ ./
RUN npm run build

# ---- Stage 2: runtime ----
FROM node:20-bookworm-slim
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       python3 python3-venv curl ca-certificates libcurl4 libssl3 \
    && rm -rf /var/lib/apt/lists/*

# MongoDB server used by the Node backend
RUN curl -fsSL https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-debian12-7.0.15.tgz \
    | tar -xz -C /opt \
    && ln -s /opt/mongodb-linux-x86_64-debian12-7.0.15/bin/mongod /usr/local/bin/mongod

WORKDIR /app
COPY server/ ./server/
COPY --from=frontend /app/frontend/build ./server/frontend/build

# Python dependencies (Django app + sentiment analyzer)
RUN python3 -m venv /venv \
    && /venv/bin/pip install --no-cache-dir -r server/requirements.txt \
       "Django>=5.0,<6.0" flask nltk

# Node dependencies for the dealers/reviews API
RUN cd server/database && npm install --omit=dev --no-audit --no-fund

ENV PATH=/venv/bin:$PATH \
    PYTHONUNBUFFERED=1

CMD ["sh", "server/start_render.sh"]
