CREATE TABLE public.user_recommendation (
 iin VARCHAR(12),
 movie_id UUID,
 period TSTZRANGE
);
INSERT INTO public.user_recommendation (iin, movie_id, period)
SELECT
 u.iin,
 m.movie_id,
 tstzrange(
 NOW() - ((random() * 365)::int * INTERVAL '1 day'),
 NOW() + ((random() * 30)::int * INTERVAL '1 day')
 )
FROM
 "user" u
CROSS JOIN LATERAL (
 SELECT movie_id
 FROM movie
 ORDER BY random()
 LIMIT 1
) m
WHERE
 random() < 0.5;