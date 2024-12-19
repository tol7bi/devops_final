CREATE TABLE public.reaction (
 user_id UUID,
 device_id UUID,
 movie_id UUID,
 reaction_type VARCHAR(50) CHECK (reaction_type IN ('dislike', 'close', 'click')),
 reaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 CHECK (user_id IS NOT NULL OR device_id IS NOT NULL)
);
DO $$
DECLARE
 batch_size INT := 1000;
 start_index INT := 1;
 end_index INT;
BEGIN
 WHILE start_index <= 100000 LOOP
  end_index := start_index + batch_size - 1;
  INSERT INTO public.reaction (user_id, device_id, movie_id, reaction_type, reaction_date)
  SELECT
    u.user_id,
    u.device_id,
    (SELECT movie_id FROM movie ORDER BY random() LIMIT 1),
    CASE WHEN random() < 0.33 THEN 'dislike'
         WHEN random() < 0.66 THEN 'close'
         ELSE 'click'
    END,
    NOW() - (random() * INTERVAL '180 days')
  FROM "user" u
  WHERE random() < 0.5
  LIMIT batch_size;
  start_index := end_index + 1;
 END LOOP;
END;
$$;
