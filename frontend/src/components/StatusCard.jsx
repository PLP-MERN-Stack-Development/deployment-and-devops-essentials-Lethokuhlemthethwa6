function StatusCard({ data }) {
  return (
    <div style={{
      marginTop: '1rem',
      padding: '1rem',
      border: '1px solid #ccc',
      borderRadius: '8px',
      textAlign: 'left',
      maxWidth: '400px',
      margin: '1rem auto'
    }}>
      <h3>Backend Status</h3>
      <p><strong>Status:</strong> {data.status}</p>
      <p><strong>Database:</strong> {data.database}</p>
      <p><strong>Uptime:</strong> {Math.floor(data.uptime)}s</p>
      <p><strong>Timestamp:</strong> {new Date(data.timestamp).toLocaleString()}</p>
    </div>
  )
}

export default StatusCard

