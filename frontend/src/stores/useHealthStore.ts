import { defineStore } from 'pinia'

// 1. Define the possible literal types for our status
type ConnectionStatus = 'success' | 'error' | null

// 2. Define the shape of our state
interface HealthState {
  message: string
  status: ConnectionStatus
  isLoading: boolean
}

// 3. Define the expected shape of the Django JSON response
interface DjangoHealthResponse {
  message: string
}

export const useHealthStore = defineStore('healthStore', {
  // Arrow function with the return type explicitly set to our HealthState interface
  state: (): HealthState => ({
    message: '',
    status: null,
    isLoading: false,
  }),

  actions: {
    async testConnection() {
      this.isLoading = true
      this.status = null
      this.message = ''

      try {
        const response = await fetch('http://localhost:8000/api/health/')

        if (!response.ok) {
          throw new Error('Failed to connect to Django')
        }

        // Cast the awaited JSON to our expected interface
        const data = (await response.json()) as DjangoHealthResponse

        this.message = data.message
        this.status = 'success'
      } catch (err) {
        console.error(err)

        // TypeScript requires us to narrow the error type since 'err' is usually 'unknown'
        if (err instanceof Error) {
          this.message = `Connection failed: ${err.message}`
        } else {
          this.message = 'Connection failed. Is Django running?'
        }

        this.status = 'error'
      } finally {
        this.isLoading = false
      }
    },
  },
})
