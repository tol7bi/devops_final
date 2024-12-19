CREATE TABLE public."user" (
 user_id UUID,
 device_id UUID,
 iin VARCHAR(20),
 name VARCHAR(100),
 email VARCHAR(150)
);
INSERT INTO public."user" (user_id, device_id, iin, name, email)
SELECT gen_random_uuid(),
 gen_random_uuid(),
 LPAD((100000000000 + i)::text, 12, '0'),
 'User ' || i,
 'user' || i || '@kbtu.devops'
FROM generate_series(1, 10000) AS i;