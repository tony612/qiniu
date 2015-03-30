defmodule Qiniu do
  def config do
    Application.get_env(:qiniu, Qiniu)
  end
end
