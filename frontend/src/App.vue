<template>
  <div class="connection-test">
    <h2>Django API Connection Test</h2>

    <button @click="healthStore.testConnection" :disabled="healthStore.isLoading" class="test-btn">
      {{ healthStore.isLoading ? 'Pinging Django...' : 'Test Connection' }}
    </button>

    <div v-if="healthStore.status" :class="['result-message', healthStore.status]">
      {{ healthStore.message }}
    </div>
  </div>
</template>

<script setup lang="ts">
import { useHealthStore } from '@/stores/useHealthStore'

// TypeScript will now automatically know the types of everything inside healthStore!
const healthStore = useHealthStore()
</script>

<style scoped>
.connection-test {
  text-align: center;
  margin: 2rem;
  padding: 2rem;
  border: 1px solid #ddd;
  border-radius: 8px;
}

.test-btn {
  padding: 10px 20px;
  font-size: 16px;
  cursor: pointer;
}

.result-message {
  margin-top: 1.5rem;
  padding: 1rem;
  border-radius: 4px;
  font-weight: bold;
}

.success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}
</style>
