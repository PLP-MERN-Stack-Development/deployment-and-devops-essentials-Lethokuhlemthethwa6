import { useState, useEffect } from 'react';
import api from '../config/api';

// Custom hook for fetching API data
export function useApi(endpoint, options = {}) {
  const [data, setData] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const fetchData = async () => {
    try {
      setLoading(true);
      setError(null);
      const response = await api.get(endpoint);
      setData(response.data);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (options.skip) return;
    fetchData();

    // Auto-refresh if interval is provided
    if (options.refreshInterval) {
      const interval = setInterval(fetchData, options.refreshInterval);
      return () => clearInterval(interval);
    }
  }, [endpoint, options.skip, options.refreshInterval]);

  return { data, loading, error, refetch: fetchData };
}

// Custom hook for backend health status
export function useHealthCheck(refreshInterval = null) {
  return useApi('/health', { refreshInterval });
}

// Custom hook for API status
export function useApiStatus(refreshInterval = null) {
  return useApi('/api/status', { refreshInterval });
}

export default useApi;
