# Variables for directories
FRONTEND_DIR := frontend
BACKEND_DIR := backend

# Phony targets to prevent conflicts with files named like our commands
.PHONY: install install-frontend install-backend dev dev-frontend dev-backend db-up db-down clean

# ==========================================
# Installation Commands
# ==========================================
install: install-backend install-frontend
	@echo All dependencies installed successfully! Use command 'make dev' to start the development servers.

install-backend:
	@echo Installing Backend dependencies...
	cd $(BACKEND_DIR) && uv sync
	@echo Backend dependencies installed.

install-frontend:
	@echo Installing Frontend dependencies...
	cd $(FRONTEND_DIR) && pnpm install
	@echo Frontend dependencies installed.

# ==========================================
# Database Commands
# ==========================================
# (Assuming you use a lightweight docker-compose just for the DB)
db-up:
	@echo Starting PostgreSQL...
	docker compose up -d

db-down:
	@echo Stopping PostgreSQL...
	docker compose down

# ==========================================
# Development Server Commands
# ==========================================
dev-backend:
	@echo Starting FastAPI backend...
	cd $(BACKEND_DIR) && uvicorn main:app --reload --host 127.0.0.1 --port 8000

dev-frontend:
	@echo Starting Vue.js...
	cd $(FRONTEND_DIR) && pnpm run dev

dev:
	@echo Starting both servers...
	$(MAKE) -j 2 dev-backend dev-frontend

# ==========================================
# Cleanup
# ==========================================
clean:
	@echo Cleaning up node_modules and Python cache...
	rm -rf $(FRONTEND_DIR)/node_modules
	find . -type d -name "__pycache__" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +