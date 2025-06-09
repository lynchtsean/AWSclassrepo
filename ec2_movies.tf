module "ec2_movies" {
  source = "./modules/ec2_instance"

  top_movies = ["Inception", "Interstellar", "Gladiator", "TheDarkKnight", "AvengersEndgame"]
}
