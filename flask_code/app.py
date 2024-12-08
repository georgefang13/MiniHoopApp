from flask import Flask, request, jsonify
import psycopg2
from psycopg2.extras import RealDictCursor

app = Flask(__name__)

def get_db_connection():
    conn = psycopg2.connect(
        dbname='swish_db',
        user='postgres',
        password='1',
        host='localhost'
    )
    return conn

@app.route('/api/shot', methods=['POST'])
def add_shot():
    data = request.json

    # Convert name to lowercase
    name = data['name'].lower()

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        'INSERT INTO shots (name, shot_made, shot_zone) VALUES (%s, %s, %s)',
        (name, data['shot_made'], data['shot_zone'])
    )
    conn.commit()
    cursor.close()
    conn.close()
    return jsonify({'message': 'Shot logged successfully'}), 201

@app.route('/api/shots', methods=['GET'])
def get_shots():
    conn = get_db_connection()
    cursor = conn.cursor(cursor_factory=RealDictCursor)
    cursor.execute('SELECT * FROM shots')
    shots = cursor.fetchall()
    cursor.close()
    conn.close()
    return jsonify(shots)

@app.route('/api/all_user_stats', methods=['GET'])
def all_user_stats():
    """
    Fetch aggregated stats for all users, including heat map data.
    """
    query = """
        SELECT 
            shots.name AS user_name,
            COUNT(*) AS shots_taken,
            SUM(CASE WHEN shots.shot_made THEN 1 ELSE 0 END) AS shots_made,
            ROUND(100.0 * SUM(CASE WHEN shots.shot_made THEN 1 ELSE 0 END) / COUNT(*), 2) AS shooting_percentage,
            json_build_object(
                '1', ROUND(100.0 * SUM(CASE WHEN shots.shot_zone = 1 AND shots.shot_made THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN shots.shot_zone = 1 THEN 1 ELSE 0 END), 0), 2),
                '2', ROUND(100.0 * SUM(CASE WHEN shots.shot_zone = 2 AND shots.shot_made THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN shots.shot_zone = 2 THEN 1 ELSE 0 END), 0), 2),
                '3', ROUND(100.0 * SUM(CASE WHEN shots.shot_zone = 3 AND shots.shot_made THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN shots.shot_zone = 3 THEN 1 ELSE 0 END), 0), 2),
                '4', ROUND(100.0 * SUM(CASE WHEN shots.shot_zone = 4 AND shots.shot_made THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN shots.shot_zone = 4 THEN 1 ELSE 0 END), 0), 2),
                '5', ROUND(100.0 * SUM(CASE WHEN shots.shot_zone = 5 AND shots.shot_made THEN 1 ELSE 0 END) / NULLIF(SUM(CASE WHEN shots.shot_zone = 5 THEN 1 ELSE 0 END), 0), 2)
            ) AS heat_map
        FROM shots
        GROUP BY shots.name
        ORDER BY shooting_percentage DESC
    """
    
    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(query)
        stats = cursor.fetchall()

        results = [
            {
                "name": row[0],
                "shotsTaken": row[1],
                "shotsMade": row[2],
                "shootingPercentage": row[3],
                "heatMap": row[4],
            }
            for row in stats
        ]
        return jsonify(results), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5050)
