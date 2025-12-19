<p align="center">
  <h1 align="center">🗳️ UW Polls — Backend API</h1>
  <p align="center">
    <strong>A robust Ruby on Rails 8 API powering real-time polling functionality</strong>
  </p>
  <p align="center">
    <a href="#tech-stack">Tech Stack</a> •
    <a href="#features">Features</a> •
    <a href="#api-reference">API Reference</a> •
    <a href="#getting-started">Getting Started</a>
  </p>
</p>

---

## ✨ Overview

This is the **backend API** for UW Polls — a modern polling platform. Built on Rails 8, it provides RESTful endpoints and GraphQL support for poll management, user authentication, and real-time vote tracking. The server implements secure session management with support for both traditional email/password and Google OAuth authentication.

<br>

## 🛠️ Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Ruby on Rails 8.0.2 |
| **Database** | SQLite3 with Active Record |
| **Authentication** | bcrypt + JWT + Google OAuth |
| **API Layer** | RESTful Controllers + GraphQL |
| **Web Server** | Puma 5.0+ |
| **CORS** | rack-cors |
| **Background Jobs** | Solid Queue |
| **Caching** | Solid Cache |
| **Real-time** | Solid Cable (Action Cable adapter) |
| **Deployment** | Docker + Kamal |

<br>

## 🎯 Features

### Authentication System
- **🔐 Dual Authentication Methods**
  - Email/Password with bcrypt encryption
  - Google OAuth 2.0 integration via JWT verification
- **🍪 Session Management** — Secure cookie-based sessions with CORS support
- **🔗 Account Linking** — Automatically links Google accounts to existing email users

### Poll Management
- **📊 CRUD Operations** — Full poll lifecycle management
- **🗳️ Vote Tracking** — Per-user vote history stored as serialized JSON
- **🔒 Duplicate Prevention** — Built-in safeguards against double voting
- **👁️ Peek Functionality** — Allow users to view results without voting

### Data Management
- **📈 Smart Sorting** — Polls sortable by popularity (total votes) or recency
- **📄 Pagination** — Efficient paginated responses for infinite scrolling
- **🎯 Filtered Queries** — Support for popular, recent, new (unvoted), and user-owned polls

<br>

## 🏗️ Architecture

```
app/
├── controllers/
│   ├── auth_controller.rb      # Authentication endpoints
│   ├── poll_controller.rb      # Poll CRUD & voting
│   └── graphql_controller.rb   # GraphQL API entry point
├── graphql/
│   ├── mutations/              # GraphQL mutations
│   ├── resolvers/              # GraphQL resolvers
│   └── types/                  # GraphQL type definitions
├── models/
│   ├── user.rb                 # User model with auth validations
│   └── poll.rb                 # Poll model with vote tracking
└── views/
    └── (API responses via jbuilder)
```

### Database Schema

```ruby
# Users Table
create_table "users" do |t|
  t.string   "email",           null: false, unique: true
  t.string   "password_digest"  # bcrypt hash
  t.string   "google_id"        # OAuth identifier
  t.datetime "created_at"
  t.datetime "updated_at"
end

# Polls Table
create_table "polls" do |t|
  t.string   "email"            # Creator email
  t.string   "title"
  t.string   "opt1", "opt2", "opt3", "opt4"  # Options
  t.integer  "res1", "res2", "res3", "res4"  # Vote counts
  t.integer  "totalvotes",      default: 0
  t.text     "user_votes",      default: "{}"  # JSON vote tracking
  t.boolean  "allow_peek_results", default: true
  t.datetime "timeposted"
end
```

<br>

## 📡 API Reference

### Authentication Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/signup` | Register with email/password |
| `POST` | `/auth/login` | Login with email/password |
| `POST` | `/auth/google` | Login/register with Google OAuth |
| `POST` | `/auth/logout` | End current session |
| `GET` | `/auth/health` | API health check |

### Poll Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/poll/popular` | Fetch polls sorted by votes |
| `GET` | `/poll/recent` | Fetch polls sorted by date |
| `GET` | `/poll/new` | Fetch unvoted polls (auth required) |
| `GET` | `/poll/mypolls` | Fetch user's own polls (auth required) |
| `POST` | `/poll/createpoll` | Create a new poll |
| `POST` | `/poll/votepoll` | Submit a vote |
| `GET` | `/poll/:id/peek` | View poll results without voting |

### GraphQL Endpoint

| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/graphql` | GraphQL API |

<br>

## 🚀 Getting Started

### Prerequisites
- Ruby 3.2+
- Bundler
- SQLite3

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/uwpolls-server.git
cd uwpolls-server

# Install dependencies
bundle install

# Setup database
bin/rails db:create db:migrate db:seed

# Start the server
bin/rails server
```

The API will be running at `http://localhost:3000`

### Environment Configuration

Configure CORS origins in `config/initializers/cors.rb` for your frontend URL.

<br>

## 🐳 Docker Deployment

```bash
# Build the Docker image
docker build -t uwpolls-server .

# Run with Docker
docker run -p 3000:3000 uwpolls-server
```

The project includes Kamal deployment configuration for streamlined production deployments.

<br>

## 🧪 Testing

```bash
# Run the test suite
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

<br>

## 🔒 Security Features

- **Password Hashing** — bcrypt with configurable cost factor
- **CORS Protection** — Strict origin whitelisting
- **Session Security** — HTTP-only cookies with SameSite attributes
- **Input Validation** — Active Record validations on all models
- **SQL Injection Prevention** — Parameterized queries via Active Record

<br>

## 📊 GraphQL Support

Access the interactive GraphQL IDE in development at `/graphiql` for exploring the API.

```graphql
# Example mutation
mutation {
  votePoll(input: { pollId: 1, optionNumber: 2 }) {
    poll {
      id
      totalvotes
      res1
      res2
    }
  }
}
```

<br>

---

<p align="center">
  <sub>Built with ❤️ using Ruby on Rails 8 and GraphQL</sub>
</p>
