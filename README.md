# 🦙 Voice + Text SQL Assistant (Telegram + PostgreSQL + n8n)

This workflow turns your Telegram bot into a voice- and text-driven AI SQL assistant.

Users can send voice messages or text prompts to the bot, and it will:

Transcribe voice to text (using OpenAI Speech-to-Text).
Use an AI agent (ChatGPT) to understand the request and generate a safe SQL query.
Execute the query against your local PostgreSQL database.
Return a natural-language response directly in the Telegram chat.

##  Workflow Overview
| Nodes                                                    | Purpose                                               |
|----------------------------------------------------------| ----------------------------------------------------- |
| **Telegram Trigger**                                     | Listens for incoming Telegram text or voice messages. |
| **Voice or Text / If / Get Voice File / Speech to Text** | Detects and converts audio messages into text.        |
| **Llama AI Assistant 🦙**                                | Understands the user query and creates SQL commands.  |
| **OpenAI Chat Model + Window Buffer Memory**             | Provides context-aware conversation history.          |
| **Execute a SQL query in Postgres**                      | Runs the AI-generated SQL on the PostgreSQL instance. |
| **Telegram (Send Message)**                              | Returns query results or messages back to the user.   |

## ⚙️ Setup Steps

Install and run n8n locally:

1. Configuration

The default PostgreSQL database name, user, and password can be customized in the .env file in the same directory.

2. Start n8n and PostgreSQL (Docker Compose)

To start n8n with PostgreSQL, run the following command in the directory containing your docker-compose.yml:

```
docker-compose up -d
```

⚠️ IMPORTANT:
Before starting, change the default values in the .env file!

To stop the services, execute:

```
docker-compose stop
```

Its required are required to expose your local n8n instance through a secure public HTTPS tunnel (via n8n.io), 
so that Telegram’s webhook can reach it over HTTPS. Check the container logs, for the UI editor URL.

```
Editor is now accessible via:

https://infinite-lambda-123.hooks.n8n.cloud
```
### Create credentials:

- Telegram Bot: Add a Telegram credential with your bot token.
- Postgres: Connect to your local DB (host, port, user, password).

**NOTE**: The hostname for the PG instance can be retrieved after inspecting the container.
Look for "Networks" -> "IPAddress".

- OpenAI: Add your OpenAI API key.

### Import this workflow into n8n.
(Click “Import” → paste the JSON from this repository.)


🧠 Example Interaction
```
You: 🎤 “Give me all records from the orders table where the total_amount is less than 100”
```
```
Bot: 💬 “Here are the records from the orders table where the total amount is less than 100:

1. Order ID: 2  
   Customer Name: Bob Smith  
   Order Date: 2025-10-02  
   Total Amount: 75.00  
   Status: Shipped”
   
2. Order ID: 4  
   Customer Name: Diana Prince  
   Order Date: 2025-10-04  
   Total Amount: 50.25  
   Status: Cancelled
...
```