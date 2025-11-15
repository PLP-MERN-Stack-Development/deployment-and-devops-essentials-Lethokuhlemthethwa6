import { useState, useEffect } from 'react';
import api from '../config/api';

export default function ConnectionTroubleshooter() {
  const [tests, setTests] = useState({
    backend: { status: 'testing', message: '' },
    cors: { status: 'testing', message: '' },
    api: { status: 'testing', message: '' },
  });

  useEffect(() => {
    runTests();
  }, []);

  const runTests = async () => {
    // Test 1: Backend reachability
    try {
      const response = await fetch('http://localhost:5000/health');
      const data = await response.json();
      setTests(prev => ({
        ...prev,
        backend: {
          status: 'success',
          message: `Backend is running (Status: ${data.status})`,
        },
      }));
    } catch (error) {
      setTests(prev => ({
        ...prev,
        backend: {
          status: 'error',
          message: `Backend not reachable: ${error.message}`,
        },
      }));
    }

    // Test 2: CORS
    try {
      const response = await fetch('http://localhost:5000/api', {
        method: 'GET',
        headers: { 'Content-Type': 'application/json' },
      });
      const corsHeader = response.headers.get('Access-Control-Allow-Origin');
      setTests(prev => ({
        ...prev,
        cors: {
          status: corsHeader ? 'success' : 'warning',
          message: corsHeader
            ? `CORS configured: ${corsHeader}`
            : 'CORS header not found',
        },
      }));
    } catch (error) {
      setTests(prev => ({
        ...prev,
        cors: {
          status: 'error',
          message: `CORS test failed: ${error.message}`,
        },
      }));
    }

    // Test 3: API Integration
    try {
      const response = await api.get('/api/status');
      setTests(prev => ({
        ...prev,
        api: {
          status: 'success',
          message: `API working (${response.data.status})`,
        },
      }));
    } catch (error) {
      setTests(prev => ({
        ...prev,
        api: {
          status: 'error',
          message: `API error: ${error.message}`,
        },
      }));
    }
  };

  return (
    <div className="bg-white rounded-lg shadow-sm p-6">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-semibold text-gray-900">Connection Diagnostics</h3>
        <button
          onClick={runTests}
          className="px-4 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700 transition text-sm"
        >
          Re-test
        </button>
      </div>

      <div className="space-y-3">
        <TestResult
          label="Backend Server"
          status={tests.backend.status}
          message={tests.backend.message}
        />
        <TestResult
          label="CORS Configuration"
          status={tests.cors.status}
          message={tests.cors.message}
        />
        <TestResult
          label="API Integration"
          status={tests.api.status}
          message={tests.api.message}
        />
      </div>

      {(tests.backend.status === 'error' || tests.api.status === 'error') && (
        <div className="mt-6 p-4 bg-yellow-50 border-l-4 border-yellow-400 rounded">
          <h4 className="text-sm font-semibold text-yellow-800 mb-2">
            Troubleshooting Tips:
          </h4>
          <ul className="text-sm text-yellow-700 space-y-1">
            <li>• Check if backend is running on port 5000</li>
            <li>• Run: <code className="bg-yellow-100 px-1 rounded">.\scripts\clean-start.ps1</code></li>
            <li>• Verify .env file has correct VITE_API_URL</li>
            <li>• Check browser console for detailed errors</li>
          </ul>
        </div>
      )}
    </div>
  );
}

function TestResult({ label, status, message }) {
  const statusConfig = {
    testing: { icon: '⏳', color: 'text-gray-600', bg: 'bg-gray-100' },
    success: { icon: '✓', color: 'text-green-600', bg: 'bg-green-100' },
    warning: { icon: '⚠', color: 'text-yellow-600', bg: 'bg-yellow-100' },
    error: { icon: '✗', color: 'text-red-600', bg: 'bg-red-100' },
  };

  const config = statusConfig[status] || statusConfig.testing;

  return (
    <div className="flex items-start space-x-3 p-3 rounded-lg bg-gray-50">
      <div className={`flex-shrink-0 w-6 h-6 rounded-full ${config.bg} flex items-center justify-center`}>
        <span className={`text-sm ${config.color}`}>{config.icon}</span>
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-sm font-medium text-gray-900">{label}</p>
        <p className={`text-sm ${config.color}`}>{message || 'Testing...'}</p>
      </div>
    </div>
  );
}
