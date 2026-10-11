/*
# Create Family Care Clinic portal data

1. New Tables
- `patients`: Shared patient profiles, clinical notes, appointment details, and status.
- `appointments`: Appointment requests submitted from the public booking form.
- `medicine_orders`: Public medicine order requests and their workflow details.
- `messages`: Messages sent to the clinic.
- `clinic_hours`: Weekly open/closed schedule managed by staff.

2. Security
- Row Level Security is enabled on every table.
- This is a single-clinic portal without account sign-in, so anon and authenticated roles may use the shared clinic data.
- Each table has separate SELECT, INSERT, UPDATE, and DELETE policies.

3. Important Notes
- Patient data is intentionally shared with the clinic's protected in-app password gate; the gate is a UX protection and not a substitute for server authentication.
- Seed records match the clinic's existing management portal list.
*/

CREATE TABLE IF NOT EXISTS patients (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_code text UNIQUE,
  full_name text NOT NULL,
  email text,
  age integer,
  gender text,
  phone text,
  address text,
  status text NOT NULL DEFAULT 'Pending',
  appointment_at timestamptz,
  symptoms text,
  medical_history text,
  diagnosis text,
  secondary_diagnosis text,
  treatment_plan text,
  remedies text,
  dosage text,
  notes text,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS appointments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  patient_name text NOT NULL,
  email text NOT NULL,
  phone text NOT NULL,
  appointment_date date NOT NULL,
  appointment_time time NOT NULL,
  symptoms text,
  status text NOT NULL DEFAULT 'Pending',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS medicine_orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  phone text NOT NULL,
  items text NOT NULL,
  address text,
  status text NOT NULL DEFAULT 'New',
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS messages (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  email text NOT NULL,
  phone text,
  subject text,
  message text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS clinic_hours (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  day_name text UNIQUE NOT NULL,
  is_open boolean NOT NULL DEFAULT true,
  morning_start time,
  morning_end time,
  evening_start time,
  evening_end time,
  sort_order integer NOT NULL
);

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE medicine_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE clinic_hours ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_read_patients" ON patients;
CREATE POLICY "public_read_patients" ON patients FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "public_insert_patients" ON patients;
CREATE POLICY "public_insert_patients" ON patients FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "public_update_patients" ON patients;
CREATE POLICY "public_update_patients" ON patients FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "public_delete_patients" ON patients;
CREATE POLICY "public_delete_patients" ON patients FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_appointments" ON appointments;
CREATE POLICY "public_read_appointments" ON appointments FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "public_insert_appointments" ON appointments;
CREATE POLICY "public_insert_appointments" ON appointments FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "public_update_appointments" ON appointments;
CREATE POLICY "public_update_appointments" ON appointments FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "public_delete_appointments" ON appointments;
CREATE POLICY "public_delete_appointments" ON appointments FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_orders" ON medicine_orders;
CREATE POLICY "public_read_orders" ON medicine_orders FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "public_insert_orders" ON medicine_orders;
CREATE POLICY "public_insert_orders" ON medicine_orders FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "public_update_orders" ON medicine_orders;
CREATE POLICY "public_update_orders" ON medicine_orders FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "public_delete_orders" ON medicine_orders;
CREATE POLICY "public_delete_orders" ON medicine_orders FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_messages" ON messages;
CREATE POLICY "public_read_messages" ON messages FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "public_insert_messages" ON messages;
CREATE POLICY "public_insert_messages" ON messages FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "public_update_messages" ON messages;
CREATE POLICY "public_update_messages" ON messages FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "public_delete_messages" ON messages;
CREATE POLICY "public_delete_messages" ON messages FOR DELETE TO anon, authenticated USING (true);

DROP POLICY IF EXISTS "public_read_hours" ON clinic_hours;
CREATE POLICY "public_read_hours" ON clinic_hours FOR SELECT TO anon, authenticated USING (true);
DROP POLICY IF EXISTS "public_insert_hours" ON clinic_hours;
CREATE POLICY "public_insert_hours" ON clinic_hours FOR INSERT TO anon, authenticated WITH CHECK (true);
DROP POLICY IF EXISTS "public_update_hours" ON clinic_hours;
CREATE POLICY "public_update_hours" ON clinic_hours FOR UPDATE TO anon, authenticated USING (true) WITH CHECK (true);
DROP POLICY IF EXISTS "public_delete_hours" ON clinic_hours;
CREATE POLICY "public_delete_hours" ON clinic_hours FOR DELETE TO anon, authenticated USING (true);

INSERT INTO patients (patient_code, full_name, email, age, gender, phone, address, status, symptoms, diagnosis, treatment_plan, remedies, dosage)
VALUES
  ('PTHR1128', 'Hassan Rehan', 'hassan@example.com', 32, 'Male', '0335 1200001', 'Butt Colony, Tandlianwala', 'Active', 'Seasonal allergy and fatigue', 'Allergic rhinitis', 'Personalized constitutional care with follow-up review.', 'Allium cepa, Nat mur', 'As prescribed'),
  ('Pt07', 'Kanwal shezadi', 'kanwal@example.com', 27, 'Female', '0335 1200002', 'Tandlianwala', 'Completed', 'Headache and sleep difficulty', 'Stress-related headache', 'Lifestyle guidance with gentle homeopathic support.', 'Kali phos', 'As prescribed'),
  ('Pt06', 'Falak sher', 'falak@example.com', 41, 'Male', '0335 1200003', 'Jhana Road, Tandlianwala', 'Active', 'Joint discomfort', 'Muscular pain', 'Review after two weeks.', 'Rhus tox', 'As prescribed'),
  ('Pt05', 'Zalaikhan', 'zalaikhan@example.com', 19, 'Female', '0335 1200004', 'Tandlianwala', 'Pending', 'Digestive discomfort', 'Indigestion', 'Diet and hydration plan.', 'Nux vomica', 'As prescribed'),
  ('Pt04', 'M aslam', 'aslam@example.com', 55, 'Male', '0335 1200005', 'Butt Colony, Tandlianwala', 'Active', 'Back stiffness', 'Chronic back pain', 'Follow-up consultation scheduled.', 'Bryonia', 'As prescribed'),
  ('Pt03', 'Humais', 'humais@example.com', 14, 'Male', '0335 1200006', 'Tandlianwala', 'Completed', 'Cough', 'Seasonal cough', 'Monitor symptoms and return if needed.', 'Spongia', 'As prescribed'),
  ('Pt02', 'Shoukat ali', 'shoukat@example.com', 46, 'Male', '0335 1200007', 'Tandlianwala', 'Active', 'Skin irritation', 'Dermatitis', 'Avoid triggers and continue plan.', 'Sulphur', 'As prescribed'),
  ('Pt01', 'Abdullah', 'abdullah@example.com', 9, 'Male', '0335 1200008', 'Tandlianwala', 'Pending', 'Low appetite', 'Appetite concern', 'Nutritional support and review.', 'Calc carb', 'As prescribed')
ON CONFLICT (patient_code) DO NOTHING;

INSERT INTO clinic_hours (day_name, is_open, morning_start, morning_end, evening_start, evening_end, sort_order)
VALUES
  ('Monday', true, '10:00', '14:00', '15:30', '20:30', 1),
  ('Tuesday', true, '10:00', '14:00', '15:30', '20:30', 2),
  ('Wednesday', true, '10:00', '14:00', '15:30', '20:30', 3),
  ('Thursday', true, '10:00', '14:00', '15:30', '20:30', 4),
  ('Friday', false, null, null, null, null, 5),
  ('Saturday', true, '10:00', '14:00', '15:30', '20:30', 6),
  ('Sunday', true, '10:00', '14:00', '15:30', '18:00', 7)
ON CONFLICT (day_name) DO NOTHING;
