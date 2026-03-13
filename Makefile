FRONTEND_DIR := frontend
BACKEND_DIR := backend
DATABASE_DIR := database

# --- OS Detection ---
ifeq ($(OS),Windows_NT)
    SHELL := cmd.exe
    # Use 'rd' for Windows and 'rm -rf' for others in the clean target
    RM_RF := rd /s /q
    # A fix for the find command on Windows
    CLEAN_PY := del /s /q *.pyc && for /d /r . %%d in (__pycache__ .pytest_cache) do @if exist "%%d" rd /s /q "%%d"
else
    SHELL := /bin/sh
    RM_RF := rm -rf
    CLEAN_PY := find . -type d -name "__pycache__" -exec rm -rf {} + && find . -type d -name ".pytest_cache" -exec rm -rf {} +
endif

.PHONY: install install-frontend install-backend dev dev-frontend dev-backend db-up db-down db-reset db-diff db-diff-force clean

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
db-up:
	@echo Starting PostgreSQL...
	docker compose up -d

db-down:
	@echo Stopping PostgreSQL...
	docker compose down

db-reset:
	@echo Resetting PostgreSQL database...
	docker compose down -v
	docker compose up -d
	@echo PostgreSQL reset complete.

# ==========================================
# Development Server Commands
# ==========================================
dev-frontend:
	@echo Starting Vue.js...
	cd $(FRONTEND_DIR) && pnpm run dev

dev-backend:
	cd backend && uv run python manage.py runserver

dev:
	@echo Starting both servers...
	@pnpm dlx concurrently -c "blue,green" -n "backend,frontend" \
		"$(MAKE) dev-backend" \
		"$(MAKE) dev-frontend"

# ==========================================
# Cleanup
# ==========================================
clean:
	@echo Cleaning up node_modules and Python cache...
	@if exist $(FRONTEND_DIR)\node_modules $(RM_RF) $(FRONTEND_DIR)\node_modules
	$(CLEAN_PY)