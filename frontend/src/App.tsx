import { ProfileForm } from './components/ProfileForm'
import './App.css'

function App() {
  return (
    <div style={{ maxWidth: '800px', margin: '0 auto', padding: '2rem' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 'bold', marginBottom: '2rem', textAlign: 'center' }}>
        職務経歴書作成
      </h1>
      <ProfileForm />
    </div>
  )
}

export default App
