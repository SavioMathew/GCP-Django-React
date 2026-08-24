
import { useState } from 'react'
import './App.css'

const initialForm = {
  student_full_name: '',
  date_of_birth: '',
  guardian_full_name: '',
  guardian_contact_number: '',
  guardian_email: '',
  learning_difficulty_category: 'DYSLEXIA',
  consent_given: false,
}

const categories = [
  'DYSLEXIA',
  'DYSGRAPHIA',
  'DYSCALCULIA',
  'ADHD',
  'AUTISM_SPECTRUM',
  'OTHER',
]

function App() {
  const [form, setForm] = useState(initialForm)
  const [result, setResult] = useState(null)
  const [loading, setLoading] = useState(false)

  const handleChange = (event) => {
    const { name, value, type, checked } = event.target

    setForm((current) => ({
      ...current,
      [name]: type === 'checkbox' ? checked : value,
    }))

    setResult(null)
  }

  const handleSubmit = async (event) => {
    event.preventDefault()
    setLoading(true)
    setResult(null)

    try {
      const response = await fetch(
        'http://localhost:8000/api/onboarding/submit/',
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
          },
          body: JSON.stringify(form),
        },
      )

      const data = await response.json()

      setResult({
        success: response.ok,
        data,
      })
    } catch (error) {
      setResult({
        success: false,
        data: {
          status: 'ERROR',
          errors: {
            connection: [
              'Could not connect to Django. Make sure the Django server is running.',
            ],
          },
        },
      })
    } finally {
      setLoading(false)
    }
  }

  return (
    <main className="app">
      <div className="card">
        <header className="header">
          <p className="eyebrow">Welcome</p>
          <h1>Student Onboarding</h1>
          <p>
            Complete the form below. DCYN validation will automatically check
            every field before accepting the submission.
          </p>
        </header>

        <form onSubmit={handleSubmit}>
          <label>
            Student full name
            <input
              name="student_full_name"
              value={form.student_full_name}
              onChange={handleChange}
              placeholder="Aarav Sharma"
              required
            />
          </label>

          <label>
            Date of birth
            <input
              type="date"
              name="date_of_birth"
              value={form.date_of_birth}
              onChange={handleChange}
              required
            />
          </label>

          <label>
            Guardian full name
            <input
              name="guardian_full_name"
              value={form.guardian_full_name}
              onChange={handleChange}
              placeholder="Priya Sharma"
              required
            />
          </label>

          <label>
            Guardian contact number
            <input
              type="tel"
              name="guardian_contact_number"
              value={form.guardian_contact_number}
              onChange={handleChange}
              placeholder="9876543210"
              required
            />
          </label>

          <label>
            Guardian email
            <input
              type="email"
              name="guardian_email"
              value={form.guardian_email}
              onChange={handleChange}
              placeholder="priya@example.com"
              required
            />
          </label>

          <label>
            Learning difficulty category
            <select
              name="learning_difficulty_category"
              value={form.learning_difficulty_category}
              onChange={handleChange}
              required
            >
              {categories.map((category) => (
                <option key={category} value={category}>
                  {category}
                </option>
              ))}
            </select>
          </label>

          <label className="consent">
            <input
              type="checkbox"
              name="consent_given"
              checked={form.consent_given}
              onChange={handleChange}
            />
            <span>I confirm that guardian consent has been given.</span>
          </label>

          <button type="submit" disabled={loading}>
            {loading ? 'Validating...' : 'Submit for Validation'}
          </button>
        </form>

        {result && (
          <section className={result.success ? 'result success' : 'result error'}>
            <h2>{result.data.status}</h2>

            {result.success ? (
              <p>
                Submission accepted. All DCYN validation checks passed.
              </p>
            ) : (
              <div>
                <p>Submission rejected by validation.</p>
                <pre>{JSON.stringify(result.data.errors, null, 2)}</pre>
              </div>
            )}
          </section>
        )}
      </div>
    </main>
  )
}

export default App

