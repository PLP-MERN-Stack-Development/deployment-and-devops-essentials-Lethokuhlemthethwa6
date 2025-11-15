import { Link } from 'react-router-dom';
import { useState, useEffect } from 'react';
import api from '../config/api';
import ConnectionTroubleshooter from '../components/ConnectionTroubleshooter';

export default function Home() {
  const [stats, setStats] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetchStats();
  }, []);

  const fetchStats = async () => {
    try {
      const response = await api.get('/api/status');
      setStats(response.data);
    } catch (error) {
      console.error('Failed to fetch stats:', error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div>
      {/* Hero Section */}
      <section className="bg-gradient-to-br from-blue-600 via-purple-600 to-pink-500 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-24">
          <div className="text-center">
            <h1 className="text-5xl md:text-6xl font-bold mb-6">
              Welcome to MERN Stack
            </h1>
            <p className="text-xl md:text-2xl mb-8 text-blue-100">
              Full-stack application with MongoDB, Express, React & Node.js
            </p>
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Link
                to="/dashboard"
                className="px-8 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-blue-50 transition"
              >
                View Dashboard
              </Link>
              <Link
                to="/about"
                className="px-8 py-3 bg-blue-700 text-white rounded-lg font-semibold hover:bg-blue-800 transition"
              >
                Learn More
              </Link>
            </div>
          </div>
        </div>
      </section>

      {/* Status Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">System Status</h2>
            <p className="text-gray-600">Real-time backend connection status</p>
          </div>

          {loading ? (
            <div className="text-center">
              <div className="inline-block animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
            </div>
          ) : stats ? (
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <StatusCard
                title="Backend Status"
                value={stats.status}
                icon="🚀"
                status={stats.status === 'operational' ? 'success' : 'error'}
              />
              <StatusCard
                title="Database"
                value={stats.database}
                icon="🗄️"
                status={stats.database === 'connected' ? 'success' : 'error'}
              />
              <StatusCard
                title="Uptime"
                value={`${Math.floor(stats.uptime / 60)}m ${Math.floor(stats.uptime % 60)}s`}
                icon="⏱️"
                status="success"
              />
            </div>
          ) : (
            <div>
              <div className="text-center text-red-600 mb-6">
                <p className="text-lg font-semibold">Unable to connect to backend</p>
                <p className="text-sm mt-2">The backend server may not be running</p>
              </div>
              <ConnectionTroubleshooter />
            </div>
          )}
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Features</h2>
            <p className="text-gray-600">Everything you need for a modern web application</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            <FeatureCard
              icon="⚡"
              title="Fast & Modern"
              description="Built with Vite and React 19 for lightning-fast development and performance."
            />
            <FeatureCard
              icon="🔒"
              title="Secure"
              description="Helmet security headers, CORS protection, and environment-based configuration."
            />
            <FeatureCard
              icon="📊"
              title="Scalable"
              description="MongoDB database with connection pooling and optimized queries."
            />
            <FeatureCard
              icon="🎨"
              title="Beautiful UI"
              description="Tailwind CSS for responsive, modern, and customizable designs."
            />
            <FeatureCard
              icon="🚀"
              title="Deploy Ready"
              description="Configured for Vercel, Netlify, Render, Railway, and more."
            />
            <FeatureCard
              icon="🔧"
              title="Developer Friendly"
              description="Hot reload, error tracking, logging, and comprehensive testing."
            />
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section className="py-16 bg-blue-600 text-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
          <h2 className="text-3xl font-bold mb-4">Ready to Get Started?</h2>
          <p className="text-xl mb-8 text-blue-100">
            Explore the dashboard and see the power of MERN stack
          </p>
          <Link
            to="/dashboard"
            className="inline-block px-8 py-3 bg-white text-blue-600 rounded-lg font-semibold hover:bg-blue-50 transition"
          >
            Open Dashboard
          </Link>
        </div>
      </section>
    </div>
  );
}

// Status Card Component
function StatusCard({ title, value, icon, status }) {
  const statusColors = {
    success: 'bg-green-100 text-green-800 border-green-200',
    error: 'bg-red-100 text-red-800 border-red-200',
    warning: 'bg-yellow-100 text-yellow-800 border-yellow-200',
  };

  return (
    <div className={`p-6 rounded-lg border-2 ${statusColors[status] || statusColors.success}`}>
      <div className="flex items-center justify-between mb-2">
        <span className="text-3xl">{icon}</span>
        <span className="text-sm font-medium uppercase tracking-wide">{status}</span>
      </div>
      <h3 className="text-lg font-semibold mb-1">{title}</h3>
      <p className="text-2xl font-bold">{value}</p>
    </div>
  );
}

// Feature Card Component
function FeatureCard({ icon, title, description }) {
  return (
    <div className="bg-white p-6 rounded-lg shadow-sm hover:shadow-md transition">
      <div className="text-4xl mb-4">{icon}</div>
      <h3 className="text-xl font-semibold text-gray-900 mb-2">{title}</h3>
      <p className="text-gray-600">{description}</p>
    </div>
  );
}
