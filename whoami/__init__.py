import logging
import random
import os
from quart import Quart


class HealthManager:

    def __init__(self):
        self.health = 100

    def is_healthy(self):
        return random.randrange(0, 100) < self.health

    def change_health(self, new_health: int) -> int:
        if 0 < new_health < 100:
            logger.info(f"Changed health from {self.health} to {new_health}")
            self.health = new_health
        return self.health


app = Quart(__name__)
logger = logging.getLogger("whoami")
health_manager = HealthManager()


@app.route("/ready", methods=["GET"])
async def ready():
    dead = os.getenv("DEAD_ON_READY_CHECK")
    if dead and dead == "true":
        logger.error("dead on ready check")
        exit(1)
    return {"status": "LAUNCHED"}, 200


@app.route("/health", methods=["GET"])
async def alive():
    if health_manager.is_healthy():
        return {"status": "READY"}, 200
    else:
        logger.warning("I am sick")
        return {"status": "SICK"}, 503


@app.route("/health/<int:new_health>", methods=["GET"])
async def change_health(new_health: int):
    return {"current_health": health_manager.change_health(new_health)}, 200


if __name__ == '__main__':
    app.run()
