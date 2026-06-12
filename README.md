# 🤖 AI Gateway — Unified Free LLM API

> **Một gateway duy nhất** tập hợp **10+ nhà cung cấp model AI miễn phí** thành một endpoint OpenAI-compatible.  
> Deploy lên **Railway** → có ngay **Base URL** + **API Key Panel** + **Admin UI** để tạo virtual keys.

---

## 📦 Bao gồm

| File | Mục đích |
|------|----------|
| `Dockerfile` | Build container với LiteLLM + Nginx Panel |
| `railway.toml` | Cấu hình deploy Railway |
| `config.yaml` | Đăng ký 30+ models từ 10 providers |
| `docker-compose.yml` | Chạy local (Postgres + Redis + Proxy) |
| `.env` | Tất cả API keys (copy vào Railway Variables) |
| `static/panel.html` | 🎨 **API Key Panel** đẹp mắt — xem/sửa/copy keys |
| `start.sh` | Script khởi động Nginx + LiteLLM |
| `nginx.conf` | Cấu hình serve panel trên port 8080 |

---

## 🚀 HƯỚNG DẪN TỪNG BƯỚC DEPLOY LÊN RAILWAY

### Bước 1: Tạo GitHub Repository

```bash
# 1. Tạo repo mới trên GitHub (ví dụ: my-ai-gateway)
# 2. Clone về máy
git clone https://github.com/YOUR_USERNAME/my-ai-gateway.git
cd my-ai-gateway

# 3. Copy toàn bộ 8 file từ ZIP này vào thư mục
#    Dockerfile, railway.toml, config.yaml, docker-compose.yml
#    .env, .dockerignore, start.sh, nginx.conf
#    static/panel.html

# 4. Commit & Push
git add .
git commit -m "Initial AI Gateway setup"
git push origin main
```

### Bước 2: Deploy lên Railway

1. Vào [Railway Dashboard](https://railway.app/dashboard)
2. Click **"New Project"** → **"Deploy from GitHub repo"**
3. Chọn repo `my-ai-gateway` vừa tạo
4. Railway tự động detect `Dockerfile` và `railway.toml`
5. **Đợi build hoàn tất** (~2-3 phút)

### Bước 3: Add PostgreSQL (BẮT BUỘC)

> ⚠️ **Không thể tạo virtual keys nếu thiếu Postgres!**

1. Trong project Railway → click **"New"** → **"Database"** → **"Add PostgreSQL"**
2. Railway tự động tạo và inject biến `DATABASE_URL` vào service của bạn
3. **Không cần làm gì thêm** — Railway auto-wires

### Bước 4: Add Redis (KHUYÊN DÙNG)

1. Trong project → **"New"** → **"Database"** → **"Add Redis"**
2. Railway tự động inject `REDIS_HOST`, `REDIS_PORT`, `REDIS_PASSWORD`
3. Redis giúp caching, rate limiting, và budget sync nhanh hơn

### Bước 5: Set Environment Variables

Vào service **my-ai-gateway** → tab **"Variables"** → click **"Raw Editor"** → paste toàn bộ từ `.env`:

```bash
# === PROVIDER KEYS (ĐÃ CÓ SẴN) ===
GROQ_API_KEY=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
OPENROUTER_API_KEY=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
NVIDIA_API_KEY=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
MISTRAL_API_KEY=Ylr6iNzABo9rsEeAUt52a8O7vxx9aKsJ
GEMINI_API_KEY=AIzaSyDxX6oEJVIzwqxpeNbDghXJm
CEREBRAS_API_KEY=csk-d688d6x66xmdefdxtpechdjmwd8pt9d63mrmhmyf2wemrwj8
COHERE_API_KEY=1lp4vsnFw8sGVi82qtAElGafn8sN1HhxN4VKl3dL
GITHUB_API_KEY=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
CLOUDFLARE_API_KEY=cfut_mv0LxWNE2wDlJY6DsZ1MxGm0AFwPAIeKFqWInRjgb2b96bbc
CLOUDFLARE_ACCOUNT_ID=c1b0874b0be59bc8dd58a2e710293e7b
UNKNOWN_API_KEY=sk-F9v1PpTAyB4CVvaXYp1894RnUdicmNKAx6pZwitfBuWWUkXehlOC0VNcd0Ivt3U8

# === BẮT BUỘC ĐỔI ===
LITELLM_MASTER_KEY=sk-thay-bang-key-bi-mat-cua-ban-32-ky-tu
LITELLM_SALT_KEY=thay-bang-salt-bi-mat-cua-ban-32-ky-tu

# === RAILWAY AUTO-WIRED (Đừng sửa) ===
DATABASE_URL=${{Postgres.DATABASE_URL}}
REDIS_HOST=${{Redis.REDIS_HOST}}
REDIS_PORT=${{Redis.REDIS_PORT}}
REDIS_PASSWORD=${{Redis.REDIS_PASSWORD}}
```

> 🔐 **QUAN TRỌNG:** Đổi `LITELLM_MASTER_KEY` và `LITELLM_SALT_KEY` thành chuỗi dài 32+ ký tự bí mật!

### Bước 6: Redeploy

Railway auto-redeploy khi variables thay đổi. Hoặc click **"Redeploy"** trong tab **Deployments**.

### Bước 7: Truy cập các endpoint

Sau khi deploy xong, Railway cấp URL dạng:
```
https://my-ai-gateway-production-xxx.up.railway.app
```

| Endpoint | URL | Mô tả |
|----------|-----|-------|
| **🎨 API Key Panel** | `https://xxx.up.railway.app:8080` hoặc mở `static/panel.html` local | Xem/sửa/copy keys |
| **🔧 Admin UI** | `https://xxx.up.railway.app/ui/` | Tạo virtual keys, quản lý models |
| **💬 Chat UI** | `https://xxx.up.railway.app/ui/chat.html` | Test chat trực tiếp |
| **📖 API Docs** | `https://xxx.up.railway.app/` | Swagger/OpenAPI docs |
| **🔗 Base URL** | `https://xxx.up.railway.app/v1` | **Endpoint chính** để gọi API |

**Login Admin UI:**
- Username: `admin`
- Password: Giá trị của `LITELLM_MASTER_KEY`

---

## 🔑 Tạo Virtual Key (API Key riêng của bạn)

1. Vào **Admin UI** → `https://xxx.up.railway.app/ui/`
2. Login với `admin` / `LITELLM_MASTER_KEY`
3. Vào **"Virtual Keys"** → **"Create Key"**
4. Đặt tên: `my-personal-key`
5. Chọn models: tick tất cả / hoặc subset
6. Set budget: `$10` (hoặc để trống = unlimited)
7. Set rate limit: `1000 req/min`
8. **Create**

Bạn sẽ nhận key dạng: `sk-litellm-abc123xyz...`

**Đây là key bạn dùng để gọi API!** Không dùng provider keys trực tiếp.

---

## 📡 Sử dụng Gateway

### Python (OpenAI SDK)
```python
from openai import OpenAI

client = OpenAI(
    api_key="sk-litellm-abc123xyz...",      # Virtual key từ Admin UI
    base_url="https://xxx.up.railway.app/v1"  # Base URL của bạn
)

response = client.chat.completions.create(
    model="groq-llama-3.3-70b",  # Chọn model từ danh sách
    messages=[{"role": "user", "content": "Hello!"}]
)
print(response.choices[0].message.content)
```

### cURL
```bash
curl https://xxx.up.railway.app/v1/chat/completions \
  -H "Authorization: Bearer sk-litellm-abc123xyz..." \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gemini-2.5-flash",
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

### JavaScript
```javascript
const response = await fetch('https://xxx.up.railway.app/v1/chat/completions', {
  method: 'POST',
  headers: {
    'Authorization': 'Bearer sk-litellm-abc123xyz...',
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    model: 'cerebras-llama-3.1-8b',
    messages: [{ role: 'user', content: 'Hello!' }]
  })
});
const data = await response.json();
console.log(data.choices[0].message.content);
```

---

## 🧠 Danh sách Model

| Model | Provider | Free Limit | Tags |
|-------|----------|------------|------|
| `groq-llama-3.3-70b` | Groq | 1,000/day | chat |
| `groq-llama-4-scout` | Groq | 1,000/day | chat |
| `groq-gemma-3` | Groq | 14,400/day | chat |
| `groq-whisper-large` | Groq | 2,000/day | audio |
| `openrouter-kimi-k2.6` | OpenRouter | 50/day | chat |
| `openrouter-llama-3.3-70b` | OpenRouter | 50/day | chat |
| `openrouter-gpt-oss-120b` | OpenRouter | 50/day | chat |
| `openrouter-deepseek-v4-flash` | OpenRouter | 50/day | chat |
| `openrouter-gemma-4-26b` | OpenRouter | 50/day | chat |
| `openrouter-qwen3-coder` | OpenRouter | 50/day | chat |
| `openrouter-glm-4.5-air` | OpenRouter | 50/day | chat |
| `nvidia-llama-3.1-70b` | NVIDIA | 40/min | chat |
| `nvidia-nemotron-3-super` | NVIDIA | 40/min | chat |
| `mistral-small` | Mistral | 1/sec | chat |
| `mistral-large` | Mistral | 1/sec | chat |
| `mistral-codestral` | Mistral | 2,000/day | chat |
| `gemini-2.5-flash` | Google | 20/day | chat |
| `gemini-3.1-flash-lite` | Google | 500/day | chat |
| `gemma-3-27b` | Google | 14,400/day | chat |
| `gemma-3-12b` | Google | 14,400/day | chat |
| `cerebras-llama-3.1-8b` | Cerebras | 14,400/day | chat |
| `cerebras-gpt-oss-120b` | Cerebras | 14,400/day | chat |
| `cohere-command-r-plus` | Cohere | 1,000/month | chat |
| `cohere-command-a` | Cohere | 1,000/month | chat |
| `cohere-aya-vision` | Cohere | 1,000/month | chat, vision |
| `github-gpt-4o` | GitHub | Token-limited | chat |
| `github-llama-3.3-70b` | GitHub | Token-limited | chat |
| `github-deepseek-r1` | GitHub | Token-limited | chat |
| `github-o3-mini` | GitHub | Token-limited | chat |
| `github-gpt-5` | GitHub | Token-limited | chat |
| `cf-llama-3.3-70b` | Cloudflare | 10K neurons/day | chat |
| `cf-gemma-3-12b` | Cloudflare | 10K neurons/day | chat |
| `cf-qwen-3-30b` | Cloudflare | 10K neurons/day | chat |
| `cf-kimi-k2.6` | Cloudflare | 10K neurons/day | chat |
| `cf-gpt-oss-120b` | Cloudflare | 10K neurons/day | chat |
| `unknown-sambanova-test` | Unknown | Testing | chat |
| `unknown-hyperbolic-test` | Unknown | Testing | chat |
| `unknown-fireworks-test` | Unknown | Testing | chat |

---

## 🐛 Chạy Local (Test trước khi deploy)

```bash
# 1. Cài Docker + Docker Compose
# 2. Trong thư mục dự án:
docker-compose up --build

# 3. Truy cập:
#    Proxy API: http://localhost:4000/v1
#    Panel:     http://localhost:8080
#    Admin UI:  http://localhost:4000/ui/
```

---

## ⚠️ Bảo mật & Lưu ý

1. **Không commit `.env` lên GitHub** — `.dockerignore` đã loại trừ
2. **Đổi `LITELLM_MASTER_KEY` và `LITELLM_SALT_KEY`** ngay sau deploy
3. **Salt key không được đổi sau khi có data** — sẽ mất hết provider keys đã encrypt
4. **Provider chưa xác định** (`sk-F9v1...`): Test với `unknown-sambanova-test`, `unknown-hyperbolic-test`, hoặc `unknown-fireworks-test`. Xem logs để xác định đúng provider.
5. **Rate limits** mỗi provider khác nhau — LiteLLM tự động fallback nếu cấu hình
6. **GitHub Models** giới hạn token rất chặt — dùng cho test, không production

---

## 📊 Tính năng có sẵn

| Feature | Status |
|---------|--------|
| ✅ 30+ models từ 10 providers | Free tier |
| ✅ Virtual Keys + Budget control | Per-key / per-team |
| ✅ Rate Limiting | Per-key / per-model |
| ✅ Load Balancing | `simple-shuffle` |
| ✅ Fallback / Retry | Auto-switch khi provider lỗi |
| ✅ Redis Caching | Giảm latency & cost |
| ✅ Spend Tracking | Theo dõi chi phí real-time |
| ✅ Admin UI | Web interface quản lý |
| ✅ OpenAI-compatible | Drop-in replacement |
| ✅ 🎨 API Key Panel | Xem/sửa/copy keys đẹp mắt |

---

## 🆘 Debug

Xem logs trong Railway Dashboard → **Deployments** → **Logs**.

Test health:
```bash
curl https://xxx.up.railway.app/health/liveliness
curl https://xxx.up.railway.app/health/readiness
```

---

**Deploy xong → bạn có ngay một AI Gateway cá nhân với Base URL `https://xxx.up.railway.app/v1`! 🎉**
