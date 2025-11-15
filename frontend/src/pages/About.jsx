export default function About() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Hero Section */}
      <section className="bg-gradient-to-r from-blue-600 to-purple-600 text-white py-20">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center">
            <h1 className="text-4xl md:text-5xl font-bold mb-4">About MERN Stack</h1>
            <p className="text-xl text-blue-100">
              Building modern full-stack applications with cutting-edge technologies
            </p>
          </div>
        </div>
      </section>

      {/* Tech Stack Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Technology Stack</h2>
            <p className="text-gray-600">The powerful technologies that power this application</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
            <TechCard
              name="MongoDB"
              icon="🍃"
              description="NoSQL database for flexible data storage"
              features={['Document-based', 'Scalable', 'High performance']}
            />
            <TechCard
              name="Express.js"
              icon="⚡"
              description="Fast and minimalist web framework"
              features={['Robust routing', 'Middleware', 'RESTful APIs']}
            />
            <TechCard
              name="React"
              icon="⚛️"
              description="Component-based UI library"
              features={['Virtual DOM', 'Hooks', 'Reusable components']}
            />
            <TechCard
              name="Node.js"
              icon="🟢"
              description="JavaScript runtime for server-side"
              features={['Event-driven', 'Non-blocking I/O', 'Fast execution']}
            />
          </div>
        </div>
      </section>

      {/* Additional Technologies */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Additional Tools</h2>
            <p className="text-gray-600">Enhanced with modern development tools</p>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-6">
            <ToolCard name="Vite" emoji="⚡" />
            <ToolCard name="Tailwind CSS" emoji="🎨" />
            <ToolCard name="React Router" emoji="🛣️" />
            <ToolCard name="Axios" emoji="🌐" />
            <ToolCard name="Winston" emoji="📝" />
            <ToolCard name="Helmet" emoji="🔒" />
          </div>
        </div>
      </section>

      {/* Features Section */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center mb-12">
            <h2 className="text-3xl font-bold text-gray-900 mb-4">Key Features</h2>
            <p className="text-gray-600">What makes this stack powerful</p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-8">
            <FeatureItem
              title="Full-Stack JavaScript"
              description="Use JavaScript/TypeScript across the entire stack - frontend, backend, and database queries."
              icon="💻"
            />
            <FeatureItem
              title="Real-time Capabilities"
              description="Built for real-time applications with WebSocket support and event-driven architecture."
              icon="⚡"
            />
            <FeatureItem
              title="Scalable Architecture"
              description="Horizontal scaling with load balancing and microservices-ready design patterns."
              icon="📈"
            />
            <FeatureItem
              title="Rich Ecosystem"
              description="Access to millions of npm packages and a vibrant community of developers."
              icon="🌍"
            />
            <FeatureItem
              title="Modern Development"
              description="Hot module replacement, fast build times, and excellent developer experience."
              icon="🚀"
            />
            <FeatureItem
              title="Production Ready"
              description="Security best practices, error handling, logging, and monitoring built-in."
              icon="✅"
            />
          </div>
        </div>
      </section>

      {/* Project Info */}
      <section className="py-16 bg-gray-50">
        <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="bg-white rounded-lg shadow-lg p-8">
            <h2 className="text-2xl font-bold text-gray-900 mb-6">About This Project</h2>
            <div className="space-y-4 text-gray-600">
              <p>
                This is a full-stack MERN application built for the PLP Week 7 Deployment Assignment.
                It demonstrates best practices in modern web development, including:
              </p>
              <ul className="list-disc list-inside space-y-2 ml-4">
                <li>RESTful API design with Express.js</li>
                <li>React 19 with modern hooks and patterns</li>
                <li>MongoDB integration with Mongoose</li>
                <li>Tailwind CSS for responsive design</li>
                <li>Environment-based configuration</li>
                <li>Security headers and CORS protection</li>
                <li>Error tracking and logging</li>
                <li>Health check endpoints for monitoring</li>
                <li>Multi-platform deployment configurations</li>
              </ul>
              <p className="pt-4">
                The application is configured for deployment on popular platforms including
                Vercel, Netlify (frontend) and Render, Railway, Heroku (backend).
              </p>
            </div>
          </div>
        </div>
      </section>
    </div>
  );
}

// Tech Card Component
function TechCard({ name, icon, description, features }) {
  return (
    <div className="bg-white rounded-lg shadow-sm hover:shadow-md transition p-6 border border-gray-100">
      <div className="text-5xl mb-4 text-center">{icon}</div>
      <h3 className="text-xl font-bold text-gray-900 mb-2 text-center">{name}</h3>
      <p className="text-gray-600 text-sm mb-4 text-center">{description}</p>
      <ul className="space-y-1">
        {features.map((feature, index) => (
          <li key={index} className="text-sm text-gray-500 flex items-start">
            <span className="text-green-500 mr-2">✓</span>
            {feature}
          </li>
        ))}
      </ul>
    </div>
  );
}

// Tool Card Component
function ToolCard({ name, emoji }) {
  return (
    <div className="bg-white rounded-lg shadow-sm hover:shadow-md transition p-4 text-center border border-gray-100">
      <div className="text-3xl mb-2">{emoji}</div>
      <p className="text-sm font-medium text-gray-900">{name}</p>
    </div>
  );
}

// Feature Item Component
function FeatureItem({ title, description, icon }) {
  return (
    <div className="flex items-start space-x-4">
      <div className="flex-shrink-0">
        <div className="flex items-center justify-center h-12 w-12 rounded-md bg-blue-500 text-white text-2xl">
          {icon}
        </div>
      </div>
      <div>
        <h3 className="text-lg font-semibold text-gray-900 mb-2">{title}</h3>
        <p className="text-gray-600">{description}</p>
      </div>
    </div>
  );
}
