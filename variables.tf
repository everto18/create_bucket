variable "buckets" {
  description = "Lista de Variaveis para Bucket"
  type        = map(list(string))
  default = {
    "appibsagencia" = ["base360"]
    "appibscoreagencia" = [
      "base_score_geral",
      "base_score_pilar",
      "base_score_tema",
      "base_score_esg_geral",
    "base_score_esg_pilar"]
    "appibslayermapa" = [
      "base_agencia_encerrada",
      "base_agencia_ativa",
    "base_agencia_tratada"]
  }
}