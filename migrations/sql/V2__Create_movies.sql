CREATE TABLE public.movie (
 movie_id uuid,
 title VARCHAR(255),
 genre VARCHAR(100),
 release_date DATE
);
INSERT INTO public.movie (movie_id, title, genre, release_date)
SELECT gen_random_uuid(),
 'Movie ' || i,
 CASE WHEN i % 3 = 0 THEN 'Action'
 WHEN i % 3 = 1 THEN 'Drama'
 ELSE 'Comedy'
 END,
 CURRENT_DATE - (i % 365) * INTERVAL '1 day'
FROM generate_series(1, 100000) AS i;